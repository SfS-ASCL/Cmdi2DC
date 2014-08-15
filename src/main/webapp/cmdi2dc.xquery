declare namespace ft="http://www.w3.org/2002/04/xquery-operators-text";
declare namespace CMD="http://www.clarin.eu/cmd/";
declare namespace functx = "http://www.functx.com";

declare function functx:is-node-in-sequence ($node as node()?, $seq as node()* )
as xs:boolean {
   some $nodeInSeq in $seq satisfies $nodeInSeq is $node
};

declare function functx:distinct-nodes ( $nodes as node()* )
as node()* {
    for $seq in (1 to count($nodes))
    return $nodes[$seq][not(functx:is-node-in-sequence(
                                .,$nodes[position() < $seq]))]
};


declare variable $cmdSchema external;
declare variable $document external;


<oai_dc:dc xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
{
	let $dcConf := <datcatmap>
			<facet name="dc:title">
				<dcid>http://www.isocat.org/datcat/DC-2536</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2537</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2544</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2545</dcid>
				<dcid>http://www.isocat.org/datcat/DC-3861</dcid>
				<dcid>http://www.isocat.org/datcat/DC-3862</dcid>
				<dcid>http://www.isocat.org/datcat/DC-4114</dcid>
				<dcid>http://www.isocat.org/datcat/DC-4160</dcid>
				<dcid>http://www.isocat.org/datcat/DC-5127</dcid>
				<dcid>http://www.isocat.org/datcat/DC-5428</dcid>
				<dcid>http://www.isocat.org/rest/dc/4160</dcid>
				<dcid>http://purl.org/dc/terms/title</dcid>
				<dcid>http://purl.org/dc/elements/1.1/title</dcid>
				<dcid>http://www.isocat.org/datcat/DC-6119</dcid>
			</facet>

			<facet name="dc:contributor">
				<dcid>http://www.isocat.org/datcat/DC-2522</dcid>
				<dcid>http://www.isocat.org/datcat/DC-3793</dcid>
				<dcid>http://www.isocat.org/datcat/DC-4115</dcid>
				<dcid>http://www.isocat.org/datcat/DC-4125</dcid>
				<dcid>http://www.isocat.org/datcat/DC-4128</dcid>
				<dcid>http://www.isocat.org/datcat/DC-5414</dcid>
			</facet>
			<facet name="dc:coverage">
			</facet>
			<facet name="dc:creator">
				<dcid>http://www.isocat.org/datcat/DC-2512</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2513</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2542</dcid>
				<dcid>http://www.isocat.org/datcat/DC-4118</dcid>
			</facet>
			<facet name="dc:date">
				<dcid>http://www.isocat.org/datcat/DC-2509</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2510</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2515</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2524</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2526</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2538</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2541</dcid>
				<dcid>http://www.isocat.org/datcat/DC-3694</dcid>
				<dcid>http://www.isocat.org/datcat/DC-4117</dcid>
				<dcid>http://purl.org/dc/terms/created</dcid>
				<dcid>http://purl.org/dc/terms/date</dcid>
				<dcid>http://purl.org/dc/terms/issued</dcid>
			</facet>
			<facet name="dc:description">
				<dcid>http://www.isocat.org/datcat/DC-2520</dcid>
				<dcid>http://www.isocat.org/datcat/DC-6124</dcid>
			</facet>
			<facet name="dc:format">
				<dcid>http://www.isocat.org/datcat/DC-2465</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2562</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2571</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2689</dcid>
				<dcid>http://www.isocat.org/datcat/DC-4085</dcid>
			</facet>
			<facet name="dc:identifier">
				<dcid>http://www.isocat.org/datcat/DC-3894</dcid>
				<dcid>http://www.isocat.org/datcat/DC-4119</dcid>
				<dcid>http://www.isocat.org/datcat/DC-4120</dcid>
			</facet>
			<facet name="dc:language">
				<dcid>http://www.isocat.org/datcat/DC-2468</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2482</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2483</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2484</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2489</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2543</dcid>
				<dcid>http://www.isocat.org/datcat/DC-5358</dcid>
				<dcid>http://www.isocat.org/datcat/DC-5361</dcid>
			</facet>
			<facet name="dc:publisher">
				<dcid>http://www.isocat.org/datcat/DC-2459</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2979</dcid>
				<dcid>http://purl.org/dc/terms/publisher</dcid>
				<dcid>http://purl.org/dc/elements/1.1/publisher</dcid>
			</facet>
			<facet name="dc:relation">
			</facet>
			<facet name="dc:rights">
				<dcid>http://www.isocat.org/datcat/DC-2453</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2456</dcid>
				<dcid>http://www.isocat.org/datcat/DC-3800</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2457</dcid>
			</facet>
			<facet name="dc:source">
			</facet>
			<facet name="dc:subject">
			</facet>

			<facet name="dc:type">
				<dcid>http://www.isocat.org/datcat/DC-3786</dcid>
				<dcid>http://www.isocat.org/datcat/DC-3789</dcid>
				<dcid>http://www.isocat.org/datcat/DC-3795</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2467</dcid>
				<dcid>http://www.isocat.org/datcat/DC-3871</dcid>
				<dcid>http://www.isocat.org/datcat/DC-2487</dcid>
				<dcid>http://www.isocat.org/datcat/DC-3804</dcid>
				<dcid>http://www.isocat.org/datcat/DC-3806</dcid>
			</facet>
		</datcatmap>

	for $facet in $dcConf//facet
	return 
		for $value in distinct-values(
			for $cmdDecl in $cmdSchema//CMD_Element,
				$dcid in $facet/dcid
			where contains($cmdDecl/@ConceptLink, $dcid/text())
			return
				for $cmd in $document/CMD:CMD/CMD:Components//*
				where contains($cmd/name(), $cmdDecl/@name)
				return 
					for $txt in $cmd/text()
					return if (normalize-space($txt) = '')
						then ()
						else $txt )
		return element {$facet/@name} {$value}
}
</oai_dc:dc>
