;;; skk-dvorakjp.el --- 拡張ローマ字入力 "DvorakJP" を SKK で使うための設定 -*- coding: utf-8 -*-

;; Copyright (C) 2003, 2007 IRIE Tetsuya <irie@t.email.ne.jp>
;; Copyright (C) 2020 YOSHIMURA Hikaru <yyu@mental.poker>

;; Author: YOSHIMURA Hikaru <yyu@mental.poker>
;; Keywords: japanese, mule, input method

;;; Commentary:
;;
;; dvorak 配列での拡張ローマ字入力 "DvorakJP" を SKK で使うための設定です．
;;   キー割当て変更点
;;                                  SKK標準     DvorakJP
;;	`skk-toggle-kana'              q         \
;;	`skk-set-henkan-point-subr'    Q         |
;;	`skk-input-by-code-or-menu'    \     割当てなし
;;	`skk-purge-from-jisyo'         X     割当てなし

;;; Code:

(eval-when-compile
  (require 'skk-macs)
  (require 'skk-vars)

  (defvar skk-jisx0201-rule-list)
  (defvar skk-jisx0201-base-rule-list))

(defvar skk-dvorakjp-unnecessary-base-rule-list
  (let ((list
         `(
           "kha" "khe" "khi" "kho" "khu"
           "dha" "dhe" "dhi" "dho" "dhu"
           "ja" "je" "ji" "jo" "ju"
           "jya" "jye" "jyi" "jyo" "jyu"
           ;;"xa" "xe" "xi" "xo" "xu"
           "xka" "xke"
           "xtsu" "xtu"
           "xwa" "xwe" "xwi"
           "xya" "xyo" "xyu"
           "bya" "bye" "byi" "byo" "byu"
           "kya" "kye" "kyi" "kyo" "kyu"
           "dya" "dye" "dyi" "dyo" "dyu"
           "fya" "fye" "fyi" "fyo" "fyu"
           "gya" "gye" "gyi" "gyo" "gyu"
           "hya" "hye" "hyi" "hyo" "hyu"
           "mya" "mye" "myi" "myo" "myu"
           "nya" "nye" "nyi" "nyo" "nyu"
           "pya" "pye" "pyi" "pyo" "pyu"
           "rya" "rye" "ryi" "ryo" "ryu"
           "sya" "sye" "syi" "syo" "syu"
           "tya" "tye" "tyi" "tyo" "tyu"
           "zh" "zj" "zk"
           "zya" "zye" "zyi" "zyo" "zyu"))
        list)))

(defvar skk-dvorakjp-additional-rom-kana-rule-list
  (let ((list
         '(
           ("\\" nil skk-toggle-kana)
           ("|" nil skk-set-henkan-point-subr)
           ("`|" nil "|")
           ("'" nil ("ッ" . "っ"))
           ("`'" nil "'")
           ("`;" nil ";")
           ("`:" nil ":")
           ("`\"" nil "\"")
           ("z/" nil "・")
           ("q." nil "…")
           ("q," nil "‥")
           ;; 標準の x* の置き換え
           ("`a" nil ("ァ" . "ぁ"))
           ("`i" nil ("ィ" . "ぃ"))
           ("`u" nil ("ゥ" . "ぅ"))
           ("`e" nil ("ェ" . "ぇ"))
           ("`o" nil ("ォ" . "ぉ"))
           ("`ca" nil ("ヵ" . "か"))
           ("`ce" nil ("ヶ" . "け"))
           ;;("`tsu" nil ("ッ" . "っ"))  ; 「↑」と衝突するのでコメントアウト
           ;;("`tu" nil ("ッ" . "っ"))  ; 「↑」と衝突するのでコメントアウト
           ("`wa" nil ("ヮ" . "ゎ"))
           ("`we" nil ("ヱ" . "ゑ"))
           ("`wi" nil ("ヰ" . "ゐ"))
           ("`ya" nil ("ャ" . "ゃ"))
           ("`yo" nil ("ョ" . "ょ"))
           ("`yu" nil ("ュ" . "ゅ"))
           ;; ヤ行の互換キー
           ("`ys" nil ("ャ" . "ゃ"))  ; リファレンスにはなし
           ("`yn" nil ("ョ" . "ょ"))  ; リファレンスにはなし
           ("`yh" nil ("ュ" . "ゅ"))  ; リファレンスにはなし
           ;; 標準の z* の置き換え
           ("`," nil "‥")
           ("`-" nil "〜")
           ("`." nil "…")
           ("`/" nil "・")
           ("`[" nil "『")
           ("`]" nil "』")
           ("`d" nil "←")
           ("`h" nil "↓")
           ("`t" nil "↑")
           ("`n" nil "→")
           ("(" nil "（")
           (")" nil "）")
           ("!" nil "！")
           ;; か行は c を使う
           ("ka" nil ("カ" . "か"))
           ("ki" nil ("キ" . "き"))
           ("ku" nil ("ク" . "く"))
           ("ke" nil ("ケ" . "け"))
           ("ko" nil ("コ" . "こ"))
           ;; 清音，濁音，撥音拡張，二重母音拡張
           (";" nil ("アン" . "あん"))
           ("x" nil ("イン" . "いん"))
           ("c" nil ("ウン" . "うん"))
           ("j" nil ("エン" . "えん"))
           ("q" nil ("オン" . "おん"))
           ("k;" nil ("カン" . "かん"))
           ("kx" nil ("キン" . "きん"))
           ;;("kk" nil ("クン" . "くん"))
           ("kj" nil ("ケン" . "けん"))
           ("kq" nil ("コン" . "こん"))
           ("k'" nil ("カイ" . "かい"))
           ("kp" nil ("クウ" . "くう"))
           ("k." nil ("ケイ" . "けい"))
           ("k," nil ("コウ" . "こう"))
           ("s;" nil ("サン" . "さん"))
           ("sx" nil ("シン" . "しん"))
           ("sc" nil ("スン" . "すん"))
           ("sj" nil ("セン" . "せん"))
           ("sq" nil ("ソン" . "そん"))
           ("s'" nil ("サイ" . "さい"))
           ("sp" nil ("スウ" . "すう"))
           ("s." nil ("セイ" . "せい"))
           ("s," nil ("ソウ" . "そう"))
           ("t;" nil ("タン" . "たん"))
           ("tx" nil ("チン" . "ちん"))
           ("tc" nil ("ツン" . "つん"))
           ("tj" nil ("テン" . "てん"))
           ("tq" nil ("トン" . "とん"))
           ("t'" nil ("タイ" . "たい"))
           ("tp" nil ("ツウ" . "つう"))
           ("t." nil ("テイ" . "てい"))
           ("t," nil ("トウ" . "とう"))
           ("n;" nil ("ナン" . "なん"))
           ("nx" nil ("ニン" . "にん"))
           ("nc" nil ("ヌン" . "ぬん"))
           ("nj" nil ("ネン" . "ねん"))
           ("nq" nil ("ノン" . "のん"))
           ("n'" nil ("ナイ" . "ない"))
           ("np" nil ("ヌウ" . "ぬう"))
           ("n." nil ("ネイ" . "ねい"))
           ("n," nil ("ノウ" . "のう"))
           ("h;" nil ("ハン" . "はん"))
           ("hx" nil ("ヒン" . "ひん"))
           ("hc" nil ("フン" . "ふん"))
           ("hj" nil ("ヘン" . "へん"))
           ("hq" nil ("ホン" . "ほん"))
           ("h'" nil ("ハイ" . "はい"))
           ("hp" nil ("フウ" . "ふう"))
           ("h." nil ("ヘイ" . "へい"))
           ("h," nil ("ホウ" . "ほう"))
           ("m;" nil ("マン" . "まん"))
           ("mx" nil ("ミン" . "みん"))
           ("mc" nil ("ムン" . "むん"))
           ("mj" nil ("メン" . "めん"))
           ("mq" nil ("モン" . "もん"))
           ("m'" nil ("マイ" . "まい"))
           ("mp" nil ("ムウ" . "むう"))
           ("m." nil ("メイ" . "めい"))
           ("m," nil ("モウ" . "もう"))
           ("y;" nil ("ヤン" . "やん"))
           ;;("yx" nil ("イン" . "いん"))  ; リファレンスにはなし
           ("yc" nil ("ユン" . "ゆん"))
           ;;("yj" nil ("イェン" . "いぇん"))  ; リファレンスにはなし
           ("yq" nil ("ヨン" . "よん"))
           ("y'" nil ("ヤイ" . "やい"))
           ("yp" nil ("ユウ" . "ゆう"))
           ("y." nil ("イウ" . "いう"))
           ("y," nil ("ヨウ" . "よう"))
           ("r;" nil ("ラン" . "らん"))
           ("rx" nil ("リン" . "りん"))
           ("rc" nil ("ルン" . "るん"))
           ("rj" nil ("レン" . "れん"))
           ("rq" nil ("ロン" . "ろん"))
           ("r'" nil ("ライ" . "らい"))
           ("rp" nil ("ルウ" . "るう"))
           ("r." nil ("レイ" . "れい"))
           ("r," nil ("ロウ" . "ろう"))
           ("w;" nil ("ワン" . "わん"))
           ("wx" nil ("ウィン" . "うぃん"))
           ("wc" nil ("ウン" . "うん"))
           ("wj" nil ("ウェン" . "うぇん"))
           ("wq" nil ("ウォン" . "うぉん"))
           ("w'" nil ("ワイ" . "わい"))
           ("wp" nil ("ウゥ" . "うぅ"))
           ("w." nil ("ウェイ" . "うぇい"))
           ("w," nil ("ウォー" . "うぉー"))
           ("g;" nil ("ガン" . "がん"))
           ("gx" nil ("ギン" . "ぎん"))
           ("gc" nil ("グン" . "ぐん"))
           ("gj" nil ("ゲン" . "げん"))
           ("gq" nil ("ゴン" . "ごん"))
           ("g'" nil ("ガイ" . "がい"))
           ("gp" nil ("グウ" . "ぐう"))
           ("g." nil ("ゲイ" . "げい"))
           ("g," nil ("ゴウ" . "ごう"))
           ("z;" nil ("ザン" . "ざん"))
           ("zx" nil ("ジン" . "じん"))
           ("zc" nil ("ズン" . "ずん"))
           ("zj" nil ("ゼン" . "ぜん"))
           ("zq" nil ("ゾン" . "ぞん"))
           ("z'" nil ("ザイ" . "ざい"))
           ("zp" nil ("ズウ" . "ずう"))
           ("z." nil ("ゼイ" . "ぜい"))
           ("z," nil ("ゾウ" . "ぞう"))
           ("d;" nil ("ダン" . "だん"))
           ("dx" nil ("ヂン" . "ぢん"))
           ("dc" nil ("ヅン" . "づん"))
           ("dj" nil ("デン" . "でん"))
           ("dq" nil ("ドン" . "どん"))
           ("d'" nil ("ダイ" . "だい"))
           ("dp" nil ("ヅウ" . "づう"))
           ("d." nil ("デイ" . "でい"))
           ("d," nil ("ドウ" . "どう"))
           ("b;" nil ("バン" . "ばん"))
           ("bx" nil ("ビン" . "びん"))
           ("bc" nil ("ブン" . "ぶん"))
           ("bj" nil ("ベン" . "べん"))
           ("bq" nil ("ボン" . "ぼん"))
           ("b'" nil ("バイ" . "ばい"))
           ("bp" nil ("ブウ" . "ぶう"))
           ("b." nil ("ベイ" . "べい"))
           ("b," nil ("ボウ" . "ぼう"))
           ("p;" nil ("パン" . "ぱん"))
           ("px" nil ("ピン" . "ぴん"))
           ("pc" nil ("プン" . "ぷん"))
           ("pj" nil ("ペン" . "ぺん"))
           ("pq" nil ("ポン" . "ぽん"))
           ("p'" nil ("パイ" . "ぱい"))
           ;;("pp" nil ("プウ" . "ぷう"))
           ("p." nil ("ペイ" . "ぺい"))
           ("p," nil ("ポウ" . "ぽう"))
           ;; 拗音，撥音拡張，二重母音拡張
           ("kna" nil ("キャ" . "きゃ"))
           ("kni" nil ("キィ" . "きぃ"))
           ("knu" nil ("キュ" . "きゅ"))
           ("kne" nil ("キェ" . "きぇ"))
           ("kno" nil ("キョ" . "きょ"))
           ("kn;" nil ("キャン" . "きゃん"))
           ("knx" nil ("キィン" . "きぃん"))
           ("knc" nil ("キュン" . "きゅん"))
           ("knj" nil ("キェン" . "きぇん"))
           ("knq" nil ("キョン" . "きょん"))
           ("kn'" nil ("キャイ" . "きゃい"))
           ("knp" nil ("キュウ" . "きゅう"))
           ("kn." nil ("キェイ" . "きぇい"))
           ("kn," nil ("キョウ" . "きょう"))
           ;; 標準でこうなっているけど一応
           ("sha" nil ("シャ" . "しゃ"))
           ("shi" nil ("シィ" . "しぃ"))  ; リファレンスでは `し' だけど
           ("shu" nil ("シュ" . "しゅ"))
           ("she" nil ("シェ" . "しぇ"))
           ("sho" nil ("ショ" . "しょ"))
           ("sh;" nil ("シャン" . "しゃん"))
           ("shx" nil ("シィン" . "しぃん"))
           ("shc" nil ("シュン" . "しゅん"))
           ("shj" nil ("シェン" . "しぇん"))
           ("shq" nil ("ション" . "しょん"))
           ("sh'" nil ("シャイ" . "しゃい"))
           ("shp" nil ("シュウ" . "しゅう"))
           ("sh." nil ("シェイ" . "しぇい"))
           ("sh," nil ("ショウ" . "しょう"))
           ("tna" nil ("チャ" . "ちゃ"))
           ("tni" nil ("チィ" . "ちぃ"))
           ("tnu" nil ("チュ" . "ちゅ"))
           ("tne" nil ("チェ" . "ちぇ"))
           ("tno" nil ("チョ" . "ちょ"))
           ("tn;" nil ("チャン" . "ちゃん"))
           ("tnx" nil ("チィン" . "ちぃん"))
           ("tnc" nil ("チュン" . "ちゅん"))
           ("tnj" nil ("チェン" . "ちぇん"))
           ("tnq" nil ("チョン" . "ちょん"))
           ("tn'" nil ("チャイ" . "ちゃい"))
           ("tnp" nil ("チュウ" . "ちゅう"))
           ("tn." nil ("チェイ" . "ちぇい"))
           ("tn," nil ("チョウ" . "ちょう"))
           ("nha" nil ("ニャ" . "にゃ"))
           ("nhi" nil ("ニィ" . "にぃ"))
           ("nhu" nil ("ニュ" . "にゅ"))
           ("nhe" nil ("ニェ" . "にぇ"))
           ("nho" nil ("ニョ" . "にょ"))
           ("nh;" nil ("ニャン" . "にゃん"))
           ("nhx" nil ("ニィン" . "にぃん"))
           ("nhc" nil ("ニュン" . "にゅん"))
           ("nhj" nil ("ニェン" . "にぇん"))
           ("nhq" nil ("ニョン" . "にょん"))
           ("nh'" nil ("ニャイ" . "にゃい"))
           ("nhp" nil ("ニュウ" . "にゅう"))
           ("nh." nil ("ニェイ" . "にぇい"))
           ("nh," nil ("ニョウ" . "にょう"))
           ("hna" nil ("ヒャ" . "ひゃ"))
           ("hni" nil ("ヒィ" . "ひぃ"))
           ("hnu" nil ("ヒュ" . "ひゅ"))
           ("hne" nil ("ヒェ" . "ひぇ"))
           ("hno" nil ("ヒョ" . "ひょ"))
           ("hn;" nil ("ヒャン" . "ひゃん"))
           ("hnx" nil ("ヒィン" . "ひぃん"))
           ("hnc" nil ("ヒュン" . "ひゅん"))
           ("hnj" nil ("ヒェン" . "ひぇん"))
           ("hnq" nil ("ヒョン" . "ひょん"))
           ("hn'" nil ("ヒャイ" . "ひゃい"))
           ("hnp" nil ("ヒュウ" . "ひゅう"))
           ("hn." nil ("ヒェイ" . "ひぇい"))
           ("hn," nil ("ヒョウ" . "ひょう"))
           ("mna" nil ("ミャ" . "みゃ"))
           ("mni" nil ("ミィ" . "みぃ"))
           ("mnu" nil ("ミュ" . "みゅ"))
           ("mne" nil ("ミェ" . "みぇ"))
           ("mno" nil ("ミョ" . "みょ"))
           ("mn;" nil ("ミャン" . "みゃん"))
           ("mnx" nil ("ミィン" . "みぃん"))
           ("mnc" nil ("ミュン" . "みゅん"))
           ("mnj" nil ("ミェン" . "みぇん"))
           ("mnq" nil ("ミョン" . "みょん"))
           ("mn'" nil ("ミャイ" . "みゃい"))
           ("mnp" nil ("ミュウ" . "みゅう"))
           ("mn." nil ("ミェイ" . "みぇい"))
           ("mn," nil ("ミョウ" . "みょう"))
           ("rha" nil ("リャ" . "りゃ"))
           ("rhi" nil ("リィ" . "りぃ"))
           ("rhu" nil ("リュ" . "りゅ"))
           ("rhe" nil ("リェ" . "りぇ"))
           ("rho" nil ("リョ" . "りょ"))
           ("rh;" nil ("リャン" . "りゃん"))
           ("rhx" nil ("リィン" . "りぃん"))
           ("rhc" nil ("リュン" . "りゅん"))
           ("rhj" nil ("リェン" . "りぇん"))
           ("rhq" nil ("リョン" . "りょん"))
           ("rh'" nil ("リャイ" . "りゃい"))
           ("rhp" nil ("リュウ" . "りゅう"))
           ("rh." nil ("リェイ" . "りぇい"))
           ("rh," nil ("リョウ" . "りょう"))
           ("gna" nil ("ギャ" . "ぎゃ"))
           ("gni" nil ("ギィ" . "ぎぃ"))
           ("gnu" nil ("ギュ" . "ぎゅ"))
           ("gne" nil ("ギェ" . "ぎぇ"))
           ("gno" nil ("ギョ" . "ぎょ"))
           ("gn;" nil ("ギャン" . "ぎゃん"))
           ("gnx" nil ("ギィン" . "ぎぃん"))
           ("gnc" nil ("ギュン" . "ぎゅん"))
           ("gnj" nil ("ギェン" . "ぎぇん"))
           ("gnq" nil ("ギョン" . "ぎょん"))
           ("gn'" nil ("ギャイ" . "ぎゃい"))
           ("gnp" nil ("ギュウ" . "ぎゅう"))
           ("gn." nil ("ギェイ" . "ぎぇい"))
           ("gn," nil ("ギョウ" . "ぎょう"))
           ("zha" nil ("ジャ" . "じゃ"))
           ("zhi" nil ("ジィ" . "じぃ"))
           ("zhu" nil ("ジュ" . "じゅ"))
           ("zhe" nil ("ジェ" . "じぇ"))
           ("zho" nil ("ジョ" . "じょ"))
           ("zh;" nil ("ジャン" . "じゃん"))
           ("zhx" nil ("ジィン" . "じぃん"))
           ("zhc" nil ("ジュン" . "じゅん"))
           ("zhj" nil ("ジェン" . "じぇん"))
           ("zhq" nil ("ジョン" . "じょん"))
           ("zh'" nil ("ジャイ" . "じゃい"))
           ("zhp" nil ("ジュウ" . "じゅう"))
           ("zh." nil ("ジェイ" . "じぇい"))
           ("zh," nil ("ジョウ" . "じょう"))
           ("dna" nil ("ヂャ" . "ぢゃ"))
           ("dni" nil ("ヂィ" . "ぢぃ"))
           ("dnu" nil ("ヂュ" . "ぢゅ"))
           ("dne" nil ("ヂェ" . "ぢぇ"))
           ("dno" nil ("ヂョ" . "ぢょ"))
           ("dn;" nil ("ヂャン" . "ぢゃん"))
           ("dnx" nil ("ヂィン" . "ぢぃん"))
           ("dnc" nil ("ヂュン" . "ぢゅん"))
           ("dnj" nil ("ヂェン" . "ぢぇん"))
           ("dnq" nil ("ヂョン" . "ぢょん"))
           ("dn'" nil ("ヂャイ" . "ぢゃい"))
           ("dnp" nil ("ヂュウ" . "ぢゅう"))
           ("dn." nil ("ヂェイ" . "ぢぇい"))
           ("dn," nil ("ヂョウ" . "ぢょう"))
           ("bna" nil ("ビャ" . "びゃ"))
           ("bni" nil ("ビィ" . "びぃ"))
           ("bnu" nil ("ビュ" . "びゅ"))
           ("bne" nil ("ビェ" . "びぇ"))
           ("bno" nil ("ビョ" . "びょ"))
           ("bn;" nil ("ビャン" . "びゃん"))
           ("bnx" nil ("ビィン" . "びぃん"))
           ("bnc" nil ("ビュン" . "びゅん"))
           ("bnj" nil ("ビェン" . "びぇん"))
           ("bnq" nil ("ビョン" . "びょん"))
           ("bn'" nil ("ビャイ" . "びゃい"))
           ("bnp" nil ("ビュウ" . "びゅう"))
           ("bn." nil ("ビェイ" . "びぇい"))
           ("bn," nil ("ビョウ" . "びょう"))
           ("pha" nil ("ピャ" . "ぴゃ"))
           ("phi" nil ("ピィ" . "ぴぃ"))
           ("phu" nil ("ピュ" . "ぴゅ"))
           ("phe" nil ("ピェ" . "ぴぇ"))
           ("pho" nil ("ピョ" . "ぴょ"))
           ("ph;" nil ("ピャン" . "ぴゃん"))
           ("phx" nil ("ピィン" . "ぴぃん"))
           ("phc" nil ("ピュン" . "ぴゅん"))
           ("phj" nil ("ピェン" . "ぴぇん"))
           ("phq" nil ("ピョン" . "ぴょん"))
           ("ph'" nil ("ピャイ" . "ぴゃい"))
           ("php" nil ("ピュウ" . "ぴゅう"))
           ("ph." nil ("ピェイ" . "ぴぇい"))
           ("ph," nil ("ピョウ" . "ぴょう"))
           ;; 拗音(2ストローク系)，撥音拡張，二重母音拡張
           ("f;" nil ("ファン" . "ふぁん"))
           ("fx" nil ("フィン" . "ふぃん"))
           ("fc" nil ("フン" . "ふん"))
           ("fj" nil ("フェン" . "ふぇん"))
           ("fq" nil ("フォン" . "ふぉん"))
           ("f'" nil ("ファイ" . "ふぁい"))
           ("fp" nil ("フウ" . "ふう"))
           ("f." nil ("フェイ" . "ふぇい"))
           ("f," nil ("フォー" . "ふぉー"))
           ("v;" nil ("ヴァン" . "う゛ぁん"))
           ("vx" nil ("ヴィン" . "う゛ぃん"))
           ("vc" nil ("ヴン" . "う゛ん"))
           ("vj" nil ("ヴェン" . "う゛ぇん"))
           ("vq" nil ("ヴォン" . "う゛ぉん"))
           ("v'" nil ("ヴァイ" . "う゛ぁい"))
           ("vp" nil ("ヴー" . "う゛ー"))
           ("v." nil ("ヴェイ" . "う゛ぇい"))
           ("v," nil ("ヴォー" . "う゛ぉー"))
           ;; ヤ行の互換キー
           ("yh" nil ("ユ" . "ゆ"))
           ("yg" nil ("ユウ" . "ゆう"))
           ("yz" nil ("ヤン" . "やん"))
           ("ym" nil ("ユン" . "ゆん"))
           ("yv" nil ("ヨン" . "よん"))
           ;; パ行の互換キー
           ("ps" nil ("パ" . "ぱ"))
           ("pd" nil ("ピ" . "ぴ"))
           ("ph" nil ("プ" . "ぷ"))
           ("pt" nil ("ペ" . "ぺ"))
           ("pz" nil ("パン" . "ぱん"))
           ("pb" nil ("ピン" . "ぴん"))
           ("pm" nil ("プン" . "ぷん"))
           ("pw" nil ("ペン" . "ぺん"))
           ("pv" nil ("ポン" . "ぽん"))
           ;; ヤ行頻出文字列の省略打ち
           ;; その他の頻出文字列の省略打ち
           ("ff" nil ("フリ" . "ふり"))
           ("fg" nil ("フル" . "ふる"))
           ("fr" nil ("フル" . "ふる"))
           ("fn" nil ("ファン" . "ふぁん"))
           ("fm" nil ("フム" . "ふむ"))
           ("gt" nil ("ゴト" . "ごと"))
           ("gn" nil ("ゴク" . "ごく"))
           ("gs" nil ("ガク" . "がく"))
           ("cr" nil ("カラ" . "から"))
           ("cd" nil ("カタ" . "かた"))
           ("ct" nil ("コト" . "こと"))
           ("cb" nil ("カンガエ" . "かんがえ"))
           ("cn" nil ("コク" . "こく"))
           ("cs" nil ("カク" . "かく"))
           ;;("rr" nil ("ラレ" . "られ"))
           ("rn" nil ("ラン" . "らん"))
           ("dg" nil ("ダガ" . "だが"))
           ("dc" nil ("デキ" . "でき"))
           ("dr" nil ("デアル" . "である"))
           ("dl" nil ("デショウ" . "でしょう"))
           ;;("dd" nil ("ノデ" . "ので"))
           ("dt" nil ("ダチ" . "だち"))
           ("ds" nil ("デス" . "です"))
           ("dm" nil ("デモ" . "でも"))
           ("hg" nil ("フル" . "ふる"))
           ("hc" nil ("ヒュウ" . "ひゅう"))
           ("hr" nil ("ヒトリ" . "ひとり"))
           ("hl" nil ("ヒョウ" . "ひょう"))
           ("hd" nil ("ホド" . "ほど"))
           ("hh" "h" ("ッ" . "っ"))
           ("hz" nil ("ヒジョウ" . "ひじょう"))
           ("tf" nil ("トリ" . "とり"))
           ("tg" nil ("トシテ" . "として"))
           ("tc" nil ("ツイテ" . "ついて"))
           ("tr" nil ("トコロ" . "ところ"))
           ("tl" nil ("トク" . "とく"))
           ("td" nil ("トイウ" . "という"))
           ("tn" nil ("トノ" . "との"))
           ("tb" nil ("タビ" . "たび"))
           ("tm" nil ("タメ" . "ため"))
           ("tv" nil ("トキ" . "とき"))
           ("tz" nil ("テキ" . "てき"))
           ("nf" nil ("ナリ" . "なり"))
           ("nc" nil ("ニツイテ" . "について"))
           ("nr" nil ("ナル" . "なる"))
           ("nl" nil ("ナッタ" . "なった"))
           ("nd" nil ("ナド" . "など"))
           ("nb" nil ("ナケレバ" . "なければ"))
           ("nm" nil ("ナクテモ" . "なくても"))
           ("nw" nil ("ナクテハ" . "なくては"))
           ("nz" nil ("ナク" . "なく"))
           ("sf" nil ("サリ" . "さり"))
           ("sg" nil ("サレ" . "され"))
           ("sc" nil ("シタ" . "した"))
           ("sr" nil ("スル" . "する"))
           ("sd" nil ("サレ" . "され"))
           ("sm" nil ("シモ" . "しも"))
           ("snb" nil ("シナケレバ" . "しなければ"))
           ("snm" nil ("シナクテモ" . "しなくても"))
           ("snt" nil ("シナクテ" . "しなくて"))
           ("snw" nil ("シナクテハ" . "しなくては"))
           ("sz" nil ("ソレゾレ" . "それぞれ"))
           ("bc" nil ("ブン" . "ぶん"))
           ("br" nil ("バラ" . "ばら"))
           ("bl" nil ("ビョウ" . "びょう"))
           ("bh" nil ("ブツ" . "ぶつ"))
           ("bt" nil ("ベツ" . "べつ"))
           ("mc" nil ("ミュー" . "みゅー"))
           ("mr" nil ("マル" . "まる"))
           ("ml" nil ("ミョウ" . "みょう"))
           ("md" nil ("マデ" . "まで"))
           ("mt" nil ("マタ" . "また"))
           ("mn" nil ("モノ" . "もの"))
           ("ms" nil ("マス" . "ます"))
           ("mm" "m" ("ッ" . "っ"))
           ("wr" nil ("ワレ" . "われ"))
           ("wt" nil ("ワタシ" . "わたし"))
           ("wn" nil ("ワレワレ" . "われわれ"))
           ("vm" nil ("コトナ" . "ことな"))
           ("vv" nil ("オナジ" . "おなじ"))
           ("zc" nil ("ジュウ" . "じゅう"))
           ("zr" nil ("ザル" . "ざる"))
           ("zt" nil ("ズツ" . "ずつ"))
           ("zn" nil ("ゾク" . "ぞく"))
           ("zs" nil ("ザク" . "ざく"))
           ("pf" nil ("プリ" . "ぷり"))
           ("pg" nil ("プル" . "ぷる"))
           ("pr" nil ("プロ" . "ぷろ"))
           ;; 拗音の打ち方(外来語)
           ("tha" nil ("テャ" . "てゃ"))
           ("thi" nil ("ティ" . "てぃ"))
           ("thu" nil ("テュ" . "てゅ"))
           ("the" nil ("テェ" . "てぇ"))
           ("tho" nil ("テョ" . "てょ"))
           ("th;" nil ("テャン" . "てゃん"))
           ("thx" nil ("ティン" . "てぃん"))
           ("thc" nil ("テュン" . "てゅん"))
           ("thj" nil ("テェン" . "てぇん"))
           ("thq" nil ("テョン" . "てょん"))
           ("th'" nil ("テャウ" . "てゃう"))
           ("thp" nil ("テュウ" . "てゅう"))
           ("th." nil ("テェイ" . "てぇい"))
           ("th," nil ("テョウ" . "てょう"))
           ("dha" nil ("デャ" . "でゃ"))
           ("dhi" nil ("ディ" . "でぃ"))
           ("dhu" nil ("デュ" . "でゅ"))
           ("dhe" nil ("デェ" . "でぇ"))
           ("dho" nil ("デョ" . "でょ"))
           ("dh;" nil ("デャン" . "でゃん"))
           ("dhx" nil ("ディン" . "でぃん"))
           ("dhc" nil ("デュン" . "でゅん"))
           ("dhj" nil ("デェン" . "でぇん"))
           ("dhq" nil ("デョン" . "でょん"))
           ("dh'" nil ("デャウ" . "でゃう"))
           ("dhp" nil ("デュウ" . "でゅう"))
           ("dh." nil ("デェイ" . "でぇい"))
           ("dh," nil ("デョウ" . "でょう"))
           ("ky" nil ("クイ" . "くい"))
           ("sy" nil ("スイ" . "すい"))
           ("ty" nil ("ツイ" . "つい"))
           ("ny" nil ("ヌイ" . "ぬい"))
           ("hy" nil ("フイ" . "ふい"))
           ("my" nil ("ムイ" . "むい"))
           ("yy" nil ("ユイ" . "ゆい"))
           ("ry" nil ("ルイ" . "るい"))
           ("wy" nil ("ウイ" . "うい"))
           ("gy" nil ("グイ" . "ぐい"))
           ("zy" nil ("ズイ" . "ずい"))
           ("dy" nil ("ヅイ" . "づい"))
           ("by" nil ("ブイ" . "ぶい"))
           ("py" nil ("プイ" . "ぷい"))
           ("cgy" nil ("キュイ" . "きゅい"))
           ("shy" nil ("シュイ" . "しゅい"))
           ("thy" nil ("テュイ" . "てゅい"))
           ("tny" nil ("チュイ" . "ちゅい"))
           ("nhy" nil ("ニュイ" . "にゅい"))
           ("hny" nil ("ヒュイ" . "ひゅい"))
           ("dny" nil ("ヂュイ" . "ぢゅい"))
           ("dhy" nil ("デュイ" . "でゅい"))
           ("bhy" nil ("ビュイ" . "びゅい"))
           ("phy" nil ("ピュイ" . "ぴゅい"))
           ("fy" nil ("フイ" . "ふい"))  ; リファレンスにはなし
           ("vy" nil ("ヴイ" . "う゛い"))
           )))
    ;; shift を押したままの二重母音拡張
    ;; `skk-special-midashi-char-list' に
    ;; < > が無い場合のみ追加する
    (unless (memq ?< skk-special-midashi-char-list)
      (setq list
            (append list
                    '(("c<" nil ("コウ" . "こう"))
                      ("s<" nil ("ソウ" . "そう"))
                      ("t<" nil ("トウ" . "とう"))
                      ("n<" nil ("ノウ" . "のう"))
                      ("h<" nil ("ホウ" . "ほう"))
                      ("m<" nil ("モウ" . "もう"))
                      ("y<" nil ("ヨウ" . "よう"))
                      ("r<" nil ("ロウ" . "ろう"))
                      ("w<" nil ("ウォー" . "うぉー"))
                      ("g<" nil ("ゴウ" . "ごう"))
                      ("z<" nil ("ゾウ" . "ぞう"))
                      ("d<" nil ("ドウ" . "どう"))
                      ("b<" nil ("ボウ" . "ぼう"))
                      ("p<" nil ("ポウ" . "ぽう"))
                      ("cg<" nil ("キョウ" . "きょう"))
                      ("sh<" nil ("ショウ" . "しょう"))
                      ("th<" nil ("チョウ" . "ちょう"))
                      ("nh<" nil ("ニョウ" . "にょう"))
                      ("hn<" nil ("ヒョウ" . "ひょう"))
                      ("mv<" nil ("ミョウ" . "みょう"))
                      ("rg<" nil ("リョウ" . "りょう"))
                      ("gr<" nil ("ギョウ" . "ぎょう"))
                      ("zm<" nil ("ジョウ" . "じょう"))
                      ("dn<" nil ("ヂョウ" . "ぢょう"))
                      ("bv<" nil ("ビョウ" . "びょう"))
                      ("pn<" nil ("ピョウ" . "ぴょう"))
                      ("f<" nil ("フォー" . "ふぉー"))
                      ("v<" nil ("ヴォー" . "う゛ぉー"))
                      ("tw<" nil ("テョウ" . "てょう"))
                      ("db<" nil ("デョウ" . "でょう"))
                      ("wm<" nil ("ウォウ" . "うぉう"))))))
    (unless (memq ?> skk-special-midashi-char-list)
      (setq list
            (append list
                    '(("c>" nil ("ケイ" . "けい"))
                      ("s>" nil ("セイ" . "せい"))
                      ("t>" nil ("テイ" . "てい"))
                      ("n>" nil ("ネイ" . "ねい"))
                      ("h>" nil ("ヘイ" . "へい"))
                      ("m>" nil ("メイ" . "めい"))
                      ("y>" nil ("イウ" . "いう"))
                      ("r>" nil ("レイ" . "れい"))
                      ("w>" nil ("ウェイ" . "うぇい"))
                      ("g>" nil ("ゲイ" . "げい"))
                      ("z>" nil ("ゼイ" . "ぜい"))
                      ("d>" nil ("デイ" . "でい"))
                      ("b>" nil ("ベイ" . "べい"))
                      ("p>" nil ("ペイ" . "ぺい"))
                      ("cg>" nil ("キェイ" . "きぇい"))
                      ("sh>" nil ("シェイ" . "しぇい"))
                      ("th>" nil ("チェイ" . "ちぇい"))
                      ("nh>" nil ("ニェイ" . "にぇい"))
                      ("hn>" nil ("ヒェイ" . "ひぇい"))
                      ("mv>" nil ("ミェイ" . "みぇい"))
                      ("rg>" nil ("リェイ" . "りぇい"))
                      ("gr>" nil ("ギェイ" . "ぎぇい"))
                      ("zm>" nil ("ジェイ" . "じぇい"))
                      ("dn>" nil ("ヂェイ" . "ぢぇい"))
                      ("bv>" nil ("ビェイ" . "びぇい"))
                      ("pn>" nil ("ピェイ" . "ぴぇい"))
                      ("f>" nil ("フェイ" . "ふぇい"))
                      ("v>" nil ("ヴェイ" . "う゛ぇい"))
                      ("tw>" nil ("テェイ" . "てぇい"))
                      ("db>" nil ("デェイ" . "でぇい"))
                      ("wm>" nil ("ウェイ" . "うぇい"))))))
    list))

;; " : は ' ; として変換させる
(setq skk-downcase-alist
      (append skk-downcase-alist '((?\" . ?\') (?: . ?\;))))

;; '「っ」 ;「あん」 Q「おん」 X「いん」 を変換ポイントに加える
(setq skk-set-henkan-point-key
      (append skk-set-henkan-point-key '(?\" ?: ?Q ?X)))

;; skk-rom-kana-base-rule-list から変換規則を削除する
(dolist (str skk-dvorakjp-unnecessary-base-rule-list)
  (setq skk-rom-kana-base-rule-list
  (skk-del-alist str skk-rom-kana-base-rule-list)))

;; skk-rom-kana-rule-list から変換規則を削除する
(let ((del-list '("hh" "mm")))
  (dolist (str del-list)
    (setq skk-rom-kana-rule-list
    (skk-del-alist str skk-rom-kana-rule-list))))

;; DvorakJP特有の変換規則を追加する
(dolist (rule skk-dvorakjp-additional-rom-kana-rule-list)
  (add-to-list 'skk-rom-kana-rule-list rule))

;; for jisx0201
(eval-after-load "skk-jisx0201"
  '(progn
     (dolist (str skk-dvorakjp-unnecessary-base-rule-list)
       (setq skk-jisx0201-base-rule-list
         (skk-del-alist str skk-jisx0201-base-rule-list)))

     (let ((del-list '("hh" "mm")))
       (dolist (str del-list)
         (setq skk-jisx0201-base-rule-list
           (skk-del-alist str skk-jisx0201-base-rule-list))))

     (dolist (rule skk-dvorakjp-additional-rom-kana-rule-list)
       (add-to-list 'skk-jisx0201-rule-list
        (if (listp (nth 2 rule))
      (list (nth 0 rule) (nth 1 rule)
            (japanese-hankaku (car (nth 2 rule))))
          rule)))

     (setq skk-jisx0201-base-rule-tree
     (skk-compile-rule-list skk-jisx0201-base-rule-list
          skk-jisx0201-rule-list))))

(run-hooks 'skk-dvorakjpy-load-hook)

;; 変換候補の選択キーをDvorakに合ったものにする。
(setq skk-henkan-show-candidates-keys '(97 111 101 117 105 100 104 116 110 115 39 44 46 112 103 99 114 108 109 119 118))

;; リターンで確定のみ
(setq skk-egg-like-newline t)

(provide 'skk-dvorakjp)

;;; skk-dvorakjp.el ends here
