#! /usr/bin/perl
# http://www.geocities.jp/shrkn65/remocon/panasonic_bsd.htm
my $bin_text = <STDIN>;

# 出力の作成
$f = 38;                # キャリア周波数は38kHz (IRKitには38と40しかない)
$t = 0.425 * 2000;      # T=0.425ms
$len = 135 * 2000;      # １送信単位を135msとする

# JSON open
$json  = qq({);
$json .= qq("format":"raw",);
$json .= qq("freq":$f,);
$json .= qq("data":[);

# リーダー部 ON(8T)->OFF(4T)
$json .= (8 * $t) . "," . (4 * $t) . ",";
$len -= 12 * $t;

# データ部 0:ON(1T)->OFF(1T), 1:ON(1T)->OFF(3T)
foreach $bit (split ("", $bin_text)) {
    if ($bit eq "0") {
        $json .= (1 * $t) . "," . (1 * $t) . ",";
        $len -= 2 * $t;
    } else {
        $json .= (1 * $t) . "," . (3 * $t) . ",";
        $len -= 4 * $t;
    }
}

# トレーラー部 ON(1T)->OFF(Nms) Nはここまでの全体が１送信単位(135ms)になるように決める
$json .= (1 * $t) . ",";
$len -= 1 * $t;
$len = 8 * 2000 if ($len < 8 * 2000); # 最小8ms
while ($len > 0) {
    if ($len >= 65536) {
        $json .= "65535,0,";
        $len -= 65535;
    } else {
        $json .= "$len";
        last;
    }
}

# JSON close
$json .= "]}\n";

# ベタ書きにしたいとき
#$json =~ s/\n//sg;
#$json .= "\n";

# 画面に出力
print $json;

# IRKitに直接コマンド発行
#$json =~ s/\n//sg;
#system qq(curl -s -i 'http://192.168.xx.xx/messages' -d '$json');

