/*
* @function  FuzzySearch
 * @param     [in]      string_array    An array of strings to query against.
 * @param     [in]      query   Any query in the form of a string_item.
 * @returns   {object}          An array of match objects consisting of the matched
 *                              string_item and information pertaining to where the match
 *                              occured within the string_item.
 */
 FuzzySearch(string_array, query) {
    if (! IsObject(string_array) || query == "")
      return 0
  
    matches := []
    re_string := ""

    for each, token in StrSplit(query)
    {
        re_string .= (re_string ? ".*?" : "") "(" token ")"
    }
    
    for each, string_item in string_array
    {
        string_item_pinyin := zh2py(string_item)
        if (RegExMatch(string_item, "i)" re_string, &re_obj)) {
            _match := {
                string_item: string_item,
                tokens: [],
                weight: Round((re_obj.Count / StrLen(string_item)) * 100)
            }

            loop re_obj.Count
            {
                m_offset    := re_obj.Pos(A_Index)
                m_restring  := (A_Index == 1 ? re_string : SubStr(m_restring, 7))
                _token      := { id: "", position: 0, weight: 0 }
                
                while (RegExMatch(string_item, "i)" m_restring, &m_obj, m_offset)) {
                _weight := m_obj.Pos(1) == 1 ? 50
                            : RegExMatch(SubStr(string_item, m_obj.Pos(1) - 1, 2)
                                    , "i)(\b|(?<=_))" m_obj[1]) ? 25 
                            : RegExMatch(SubStr(string_item, m_obj.Pos(1), 1), "\p{Lu}") ? 10 : 01

                if (_weight > _token.weight)
                    _token.id := m_obj[1]
                    , _token.weight   := _weight
                    , _token.position := m_obj.Pos(1)
                
                m_offset := m_obj.Pos(1) + 1
                }

                _match.tokens.Push(_token.position, _token.id)
                _match.weight += _token.weight
            }
            matches.Push(_match)
        }
        else if (RegExMatch(string_item_pinyin, "i)" re_string, &re_obj)) {
            _match := {
                string_item: string_item,
                tokens: [],
                weight: Round((re_obj.Count / StrLen(string_item_pinyin)) * 100)
            }

            loop re_obj.Count
            {
                m_offset    := re_obj.Pos(A_Index)
                m_restring  := (A_Index == 1 ? re_string : SubStr(m_restring, 7))
                _token      := { id: "", position: 0, weight: 0 }
                
                while (RegExMatch(string_item_pinyin, "i)" m_restring, &m_obj, m_offset)) {
                _weight := m_obj.Pos(1) == 1 ? 50
                            : RegExMatch(SubStr(string_item_pinyin, m_obj.Pos(1) - 1, 2)
                                    , "i)(\b|(?<=_))" m_obj[1]) ? 25 
                            : RegExMatch(SubStr(string_item_pinyin, m_obj.Pos(1), 1), "\p{Lu}") ? 10 : 01

                if (_weight > _token.weight)
                    _token.id := m_obj[1]
                    , _token.weight   := _weight
                    , _token.position := m_obj.Pos(1)
                
                m_offset := m_obj.Pos(1) + 1
                }

                _match.tokens.Push(_token.position, _token.id)
                _match.weight += _token.weight
            }
            matches.Push(_match)
        }
    }
    ; 排序并删除多余信息
    BubbleSort(matches)
    results := []
    for value in matches {
        results.Push(value.string_item)
    }
    return results
}

; 冒泡排序函数
BubbleSort(arr) {
    local swapped, temp
    swapped := true

    while swapped {
        swapped := false
        for i, value in arr {
            if (i < arr.Length) {
                if (arr[i].weight < arr[i + 1].weight) {
                    ; 交换位置
                    temp := arr[i]
                    arr[i] := arr[i + 1]
                    arr[i + 1] := temp
                    swapped := true
                }
            }
        }
    }
}

zh2py(str)
{
	; 根据汉字区位表,(http://www.mytju.com/classcode/tools/QuWeiMa_FullList.asp)
	; 我们可以看到从16-55区之间是按拼音字母排序的,所以我们只需要判断某个汉字的区位码就可以得知它的拼音首字母.
	; 区位表第一部份,按拼音字母排序的.
	; 16区-55区
	/*
		'A'=>0xB0A1, 'B'=>0xB0C5, 'C'=>0xB2C1, 'D'=>0xB4EE, 'E'=>0xB6EA, 'F'=>0xB7A2, 'G'=>0xB8C1,'H'=>0xB9FE,
		'J'=>0xBBF7, 'K'=>0xBFA6, 'L'=>0xC0AC, 'M'=>0xC2E8, 'N'=>0xC4C3, 'O'=>0xC5B6, 'P'=>0xC5BE,'Q'=>0xC6DA,
		'R'=>0xC8BB, 'S'=>0xC8F6, 'T'=>0xCBFA, 'W'=>0xCDDA, 'X'=>0xCEF4, 'Y'=>0xD1B9, 'Z'=>0xD4D1
	*/
	static FirstTable  := [ 0xB0C5, 0xB2C1, 0xB4EE, 0xB6EA, 0xB7A2, 0xB8C1, 0xB9FE, 0xBBF7, 0xBFA6, 0xC0AC, 0xC2E8
	                      , 0xC4C3, 0xC5B6, 0xC5BE, 0xC6DA, 0xC8BB, 0xC8F6, 0xCBFA, 0xCDDA, 0xCEF4, 0xD1B9, 0xD4D1, 0xD7FA ]
	static FirstLetter := StrSplit("ABCDEFGHJKLMNOPQRSTWXYZ")
	; 区位表第二部份,不规则的,下面的字母是每个区里面对应字的拼音首字母.从网上查询整理出来的,可能会有部份错误.
	; 56区-87区
	static SecondTable := [ StrSplit("CJWGNSPGCGNEGYPBTYYZDXYKYGTZJNMJQMBSGZSCYJSYYFPGKBZGYDYWJKGKLJSWKPJQHYJWRDZLSYMRYPYWWCCKZNKYYG")
	                      , StrSplit("TTNGJEYKKZYTCJNMCYLQLYPYSFQRPZSLWBTGKJFYXJWZLTBNCXJJJJTXDTTSQZYCDXXHGCKBPHFFSSTYBGMXLPBYLLBHLX")
	                      , StrSplit("SMZMYJHSOJNGHDZQYKLGJHSGQZHXQGKXZZWYSCSCJXYEYXADZPMDSSMZJZQJYZCJJFWQJBDZBXGZNZCPWHWXHQKMWFBPBY")
	                      , StrSplit("DTJZZKXHYLYGXFPTYJYYZPSZLFCHMQSHGMXXSXJYQDCSBBQBEFSJYHWWGZKPYLQBGLDLCDTNMAYDDKSSNGYCSGXLYZAYPN")
	                      , StrSplit("PTSDKDYLHGYMYLCXPYCJNDQJWXQXFYYFJLEJPZRXCCQWQQSBZKYMGPLBMJRQCFLNYMYQMSQYRBCJTHZTQFRXQHXMQJCJLY")
	                      , StrSplit("QGJMSHZKBSWYEMYLTXFSYDXWLYCJQXSJNQBSCTYHBFTDCYZDJWYGHQFRXWCKQKXEBPTLPXJZSRMEBWHJLBJSLYYSMDXLCL")
	                      , StrSplit("QKXLHXJRZJMFQHXHWYWSBHTRXXGLHQHFNMGYKLDYXZPYLGGSMTCFBAJJZYLJTYANJGBJPLQGSZYQYAXBKYSECJSZNSLYZH")
	                      , StrSplit("ZXLZCGHPXZHZNYTDSBCJKDLZAYFFYDLEBBGQYZKXGLDNDNYSKJSHDLYXBCGHXYPKDJMMZNGMMCLGWZSZXZJFZNMLZZTHCS")
	                      , StrSplit("YDBDLLSCDDNLKJYKJSYCJLKWHQASDKNHCSGAGHDAASHTCPLCPQYBSZMPJLPCJOQLCDHJJYSPRCHNWJNLHLYYQYYWZPTCZG")
	                      , StrSplit("WWMZFFJQQQQYXACLBHKDJXDGMMYDJXZLLSYGXGKJRYWZWYCLZMSSJZLDBYDCFCXYHLXCHYZJQSQQAGMNYXPFRKSSBJLYXY")
	                      , StrSplit("SYGLNSCMHCWWMNZJJLXXHCHSYZSTTXRYCYXBYHCSMXJSZNPWGPXXTAYBGAJCXLYXDCCWZOCWKCCSBNHCPDYZNFCYYTYCKX")
	                      , StrSplit("KYBSQKKYTQQXFCMCHCYKELZQBSQYJQCCLMTHSYWHMKTLKJLYCXWHEQQHTQKZPQSQSCFYMMDMGBWHWLGSLLYSDLMLXPTHMJ")
	                      , StrSplit("HWLJZYHZJXKTXJLHXRSWLWZJCBXMHZQXSDZPSGFCSGLSXYMJSHXPJXWMYQKSMYPLRTHBXFTPMHYXLCHLHLZYLXGSSSSTCL")
	                      , StrSplit("SLDCLRPBHZHXYYFHBMGDMYCNQQWLQHJJCYWJZYEJJDHPBLQXTQKWHLCHQXAGTLXLJXMSLJHTZKZJECXJCJNMFBYCSFYWYB")
	                      , StrSplit("JZGNYSDZSQYRSLJPCLPWXSDWEJBJCBCNAYTWGMPAPCLYQPCLZXSBNMSGGFNZJJBZSFZYNTXHPLQKZCZWALSBCZJXSYZGWK")
	                      , StrSplit("YPSGXFZFCDKHJGXTLQFSGDSLQWZKXTMHSBGZMJZRGLYJBPMLMSXLZJQQHZYJCZYDJWFMJKLDDPMJEGXYHYLXHLQYQHKYCW")
	                      , StrSplit("CJMYYXNATJHYCCXZPCQLBZWWYTWBQCMLPMYRJCCCXFPZNZZLJPLXXYZTZLGDLTCKLYRZZGQTTJHHHJLJAXFGFJZSLCFDQZ")
	                      , StrSplit("LCLGJDJZSNZLLJPJQDCCLCJXMYZFTSXGCGSBRZXJQQCTZHGYQTJQQLZXJYLYLBCYAMCSTYLPDJBYREGKLZYZHLYSZQLZNW")
	                      , StrSplit("CZCLLWJQJJJKDGJZOLBBZPPGLGHTGZXYGHZMYCNQSYCYHBHGXKAMTXYXNBSKYZZGJZLQJTFCJXDYGJQJJPMGWGJJJPKQSB")
	                      , StrSplit("GBMMCJSSCLPQPDXCDYYKYPCJDDYYGYWRHJRTGZNYQLDKLJSZZGZQZJGDYKSHPZMTLCPWNJYFYZDJCNMWESCYGLBTZZGMSS")
	                      , StrSplit("LLYXYSXXBSJSBBSGGHFJLYPMZJNLYYWDQSHZXTYYWHMCYHYWDBXBTLMSYYYFSXJCBDXXLHJHFSSXZQHFZMZCZTQCXZXRTT")
	                      , StrSplit("DJHNRYZQQMTQDMMGNYDXMJGDXCDYZBFFALLZTDLTFXMXQZDNGWQDBDCZJDXBZGSQQDDJCMBKZFFXMKDMDSYYSZCMLJDSYN")
	                      , StrSplit("SPRSKMKMPCKLGTBQTFZSWTFGGLYPLLJZHGJJGYPZLTCSMCNBTJBQFKDHBYZGKPBBYMTDSSXTBNPDKLEYCJNYCDYKZTDHQH")
	                      , StrSplit("SYZSCTARLLTKZLGECLLKJLQJAQNBDKKGHPJTZQKSECSHALQFMMGJNLYJBBTMLYZXDXJPLDLPCQDHZYCBZSCZBZMSLJFLKR")
	                      , StrSplit("ZJSNFRGJHXPDHYJYBZGDLQCSEZGXLBLGYXTWMABCHECMWYJYZLLJJYHLGNDJLSLYGKDZPZXJYYZLWCXSZFGWYYDLYHCLJS")
	                      , StrSplit("CMBJHBLYZLYCBLYDPDQYSXQZBYTDKYXJYYCNRJMPDJGKLCLJBCTBJDDBBLBLCZQRPYXJCJLZCSHLTOLJNMDDDLNGKATHQH")
	                      , StrSplit("JHYKHEZNMSHRPHQQJCHGMFPRXHJGDYCHGHLYRZQLCYQJNZSQTKQJYMSZSWLCFQQQXYFGGYPTQWLMCRNFKKFSYYLQBMQAMM")
	                      , StrSplit("MYXCTPSHCPTXXZZSMPHPSHMCLMLDQFYQXSZYJDJJZZHQPDSZGLSTJBCKBXYQZJSGPSXQZQZRQTBDKYXZKHHGFLBCSMDLDG")
	                      , StrSplit("DZDBLZYYCXNNCSYBZBFGLZZXSWMSCCMQNJQSBDQSJTXXMBLTXZCLZSHZCXRQJGJYLXZFJPHYMZQQYDFQJJLZZNZJCDGZYG")
	                      , StrSplit("CTXMZYSCTLKPHTXHTLBJXJLXSCDQXCBBTJFQZFSLTJBTKQBXXJJLJCHCZDBZJDCZJDCPRNPQCJPFCZLCLZXZDMXMPHJSGZ")
	                      , StrSplit("GSZZQLYLWTJPFSYASMCJBTZYYCWMYTZSJJLJCQLWZMALBXYFBPNLSFHTGJWEJJXXGLLJSTGSHJQLZFKCGNNNSZFDEQFHBS")
	                      , StrSplit("AQTGYLBXMMYGSZLDYDQMJJRGBJTKGDHGKBLQKBDMBYLXWCXYTTYBKMRTJZXQJBHLMHMJJZMQASLDCYXYQDLQCAFYWYXQHZ") ]
	
	; 如果不包含中文字符，则直接返回原字符
	if (!RegExMatch(str, "[^\x00-\xff]"))
		Return str
	
	Loop Parse, str
	{
        encoding := "CP936"
        buf := Buffer(StrPut(str, encoding))
		StrPut(A_LoopField, buf, encoding)
		H := NumGet(buf, 0, "UChar")
		L := NumGet(buf, 1, "UChar")
		
		; 字符集非法
		if (H < 0xB0 || L < 0xA1 || H > 0xF7 || L = 0xFF)
		{
			newStr .= A_LoopField
			Continue
		}
		
		if (H < 0xD8)//(H >= 0xB0 && H <=0xD7) ; 查询文字在一级汉字区(16-55)
		{
			W := (H << 8) | L
			For key, value in FirstTable
			{
				if (W < value)
				{
					newStr .= FirstLetter[key]
					Break
				}
			}
		}
		else ; if (H >= 0xD8 && H <= 0xF7) ; 查询中文在二级汉字区(56-87)
			newStr .= SecondTable[ H - 0xD8 + 1 ][ L - 0xA1 + 1 ]
	}
	
	Return newStr
}