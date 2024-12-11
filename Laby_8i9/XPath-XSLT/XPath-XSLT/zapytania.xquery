for $k in doc('file:///C:/Users/krzys/Desktop/Studia/Studia_semestr_2/ZTPD/Laby/Laby_8i9/XPath-XSLT/XPath-XSLT/swiat.xml')
    //KRAJ
where substring($k/NAZWA, 1, 1) = substring($k/STOLICA, 1, 1)
return <KRAJ>
 {$k/NAZWA, $k/STOLICA}
</KRAJ>
