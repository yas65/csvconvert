require 'kconv'

class RisonaBankFormat
  #元テーブルの仕様
  #法人ID,拠点ID,契約者番号,銀行番号,支店番号,口座種別,口座番号,口座名義
  #変換後ファイルの仕様
  #2,銀行番号,支店番号,口座種別,口座番号,口座名義,-,-,口座名義カナ,-,振替請求番号,-,-,-,-,-,-,-,-,-,-,-,-,-
  def convert_table
      ["header",{"supplement"=>[3,4]},{"supplement"=>[4,3]},5,{"supplement"=>[6,7]},7,"no","no",7,"no","demand_unit","no","no","no","no","no","no","no","no","no","no","no","no","no"]
  end
  def header(line=nil)
    2
  end
  def demand_unit(line=nil)
    if line[0] =~ /^11/
      "#{line[2]}#{adj_corporation_id(line[0])}000000100"
    else
      "#{line[2]}#{adj_corporation_id(line[1])}00200"
    end
  end
  def no(line=nil)
    ""
  end
  def supplement(value,digit,character="0")
    supp = ""
    1.upto(digit - value.size) do
       supp += character
    end
    supp + value
  end
  def adj_corporation_id(origin)
    if origin =~ /^11/
      origin.to_s
    else
      "0"+ origin.to_s
    end
  end  
  def convert(rows)
    target_lines = []
    line_no = 0
    rows.each do |line|
      p line_no +=1 
      next if line[0] == nil
      target_line = []
      convert_table.each_with_index do |column,index|
        if convert_table[index].class == String
          target_line[index] = self.__send__(convert_table[index],line)
        elsif convert_table[index].class == Hash
          tmp_hash = convert_table[index]
          tmp_hash.each_key do |key|
            target_line[index] = self.__send__(key,line[tmp_hash[key][0]],tmp_hash[key][1]).to_s.tosjis
          end
        else
          target_line[index] = line[convert_table[index]].to_s.tosjis if convert_table[index]
        end
      end
      while target_line.size < 24
        target_line.push("")
      end
      if target_line[10].size != 20 
        p "Illegal Member Id #{line[0]} #{target_line[10]} #{line_no}"
      else
        target_lines.push(target_line)
      end
    end
    target_lines
  end
end