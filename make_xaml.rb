# hash = {3 => ["亡","寸","己","干"], 4 => ["仁","収","尺","片"], 5 => ["冊","処","幼","庁","穴"], 
#     6 => ["后","吸","存","宅","宇","机","灰","至"], 
#     7 => ["乱","卵","否","困","孝","忘","我","批","私","系"],
#     8 => ["並","乳","供","刻","呼","垂","宗","宙","宝","届","延","忠","担","拝","拡","枚","沿","若"],
#     9 => ["城","奏","姿","宣","専","巻","律","映","染","段","泉","洗","派","皇","看","砂","紅","肺","背","革"]
#     # ...
#     # 9 => ["保","則","厚","政","故","査","独","祖","迷","退","逆","限"],
#     # 10 => ["修","俵","個","容","師","恩","格","桜","留","益","破","素","耕","能","財","造"],
#     # 11 => ["務","基","婦","寄","常","張","情","授","採","接","断","液","混","率","現","略","眼","移","経","術","規","設","許","貧","責","険"],
#     # 12 => ["備","営","報","富","属","復","提","検","減","測","程","税","統","絶","証","評","貸","貿","賀","過"],
#     # 13 => ["勢","墓","夢","幹","損","準","禁","罪","群","義","解","豊","資","鉱","預","飼"],
#     # 14 => ["像","境","増","徳","態","慣","構","演","精","綿","総","製","複","適","酸","銅","銭","際","雑","領"],
#     # 15 => ["導","敵","暴","潔","確","編","賛","質"],
#     # 16 => ["燃","築","興","衛","輸"],
#     # 17 => ["績","講","謝"],
#     # 18 => ["織","職","額"],
#     # 19 => ["識"],
#     # 20 => ["護"]
# }

require 'nokogiri'
require 'open-uri'

hash_arr = (1..6).map do |i| 
    # puts "#{i}年生"
    doc = Nokogiri::HTML(open("https://www.nihongo-pro.com/jp/kanji-pal/list/grade/#{i}/strokes"))

    hash = doc.css('.outputList').map do |a| 
        num = a.css(".outputListName").text.gsub(/ 画(.+ 字)/, "")[0..-2]
        kanjis = a.css(".kanji_clickable").text

        if num == ""
            next
        end
        [num.to_i, kanjis.split("")]
    end.compact.to_h

    # p hash
    # puts "\n"
end

hash_i = 0
result = hash_arr.map do |hash|
    hash_i += 1
    borders = hash.to_enum.with_index.map do |kv,i| 
        k = kv[0]
        v = kv[1]
        borders = v.map do |kanji| 
            s=<<EOM
    <Border BorderBrush="Black" HorizontalAlignment="Center" BorderThickness="2" Background="White" Height="145" Width="145" Margin="13,0,0,10" Tapped="MoveMakeQuestion">
                        <TextBlock  FontSize="120" HorizontalAlignment="Center" Text="#{kanji}" TextWrapping="Wrap" VerticalAlignment="Top" Height="140" Width="140" Margin="17,-12,0,0" />
                    </Border>
EOM
        s
        end.join("\n")

        margin_top = 250 + 200 * (i - 1);
        <<EOM
        <Grid>
            <TextBlock FontSize="60" HorizontalAlignment="Left" Margin="87,0,0,0" Text="#{k}画" TextWrapping="Wrap" VerticalAlignment="Top" Height="74" Width="175"/>
            <GridView ScrollViewer.VerticalScrollMode="Disabled" Margin="217,0,0,0" VerticalAlignment="Top">
                #{borders}
            </GridView>
        </Grid>
EOM
    end.join("\n")

    File.write("result#{hash_i}grade.txt", borders)
    borders
end

# borders = hash.to_enum.with_index.map do |kv,i| 
#     k = kv[0]
#     v = kv[1]
#     borders = v.map do |kanji| 
#         s=<<EOM
# <Border BorderBrush="Black" HorizontalAlignment="Center" BorderThickness="2" Background="White" Height="145" Width="145" Margin="13,0,0,10" Tapped="MoveMakeQuestion">
#                     <TextBlock  FontSize="120" HorizontalAlignment="Center" Text="#{kanji}" TextWrapping="Wrap" VerticalAlignment="Top" Height="140" Width="140" Margin="17,-12,0,0" />
#                 </Border>
# EOM
#     s
#     end.join("\n")

#     margin_top = 250 + 200 * (i - 1);
#     <<EOM
#     <Grid>
#         <TextBlock FontSize="60" HorizontalAlignment="Left" Margin="87,0,0,0" Text="#{k}画" TextWrapping="Wrap" VerticalAlignment="Top" Height="74" Width="175"/>
#         <GridView ScrollViewer.VerticalScrollMode="Disabled" Margin="217,0,0,0" VerticalAlignment="Top">
#             #{borders}
#         </GridView>
#     </Grid>
# EOM
# end.join("\n\n")

puts result