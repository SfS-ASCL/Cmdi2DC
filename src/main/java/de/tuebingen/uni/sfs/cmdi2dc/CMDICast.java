package de.tuebingen.uni.sfs.cmdi2dc;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.Properties;
import javax.xml.namespace.QName;
import javax.xml.transform.OutputKeys;
import javax.xml.xquery.XQConnection;
import javax.xml.xquery.XQDataSource;
import javax.xml.xquery.XQPreparedExpression;
import javax.xml.xquery.XQResultSequence;
import net.sf.saxon.xqj.SaxonXQDataSource;

public class CMDICast {

	public static void main(String[] args) throws Exception {
		test();
	}

	public static void test() throws Exception {
		File result = castFile("annotated_english_gigaword.cmdi");
		System.out.println("first done");
		castFile("annotated_english_gigaword.cmdi");
		System.out.println("second done");
		castFile("annotated_english_gigaword.cmdi");
		System.out.println("third done");
	}

	public static File castFile(String cmdifilename) throws Exception {
		return castFile(new File(cmdifilename));
	}

	public static InputStream getInputStream(String filename) {
		System.out.println(filename + "");
		try {
			return new FileInputStream(filename);
		} catch (FileNotFoundException xc) {
		}
		System.out.println(filename + " from webapp");
		try {
			return new FileInputStream("src/main/webapp/" + filename);
		} catch (FileNotFoundException xc) {
		}

		ClassLoader cl = Thread.currentThread().getContextClassLoader();
		System.out.println(filename + " as resource");
		InputStream is = cl.getResourceAsStream(filename);
		return (is != null) ? is
				: cl.getResourceAsStream("../../" + filename);
	}

	public static File castFile(File cmdifile) throws Exception {
		XQDataSource ds = new SaxonXQDataSource();
		XQConnection conn = ds.getConnection();

		try (InputStream cmdi2dc = getInputStream("cmdi2dc.xquery");
				InputStream cmdSchema = getInputStream("cmdSchema.xml");
				InputStream document = new FileInputStream(cmdifile)) {
			XQPreparedExpression expr = conn.prepareExpression(cmdi2dc);
			expr.bindDocument(new QName("cmdSchema"), cmdSchema, null, null);
			expr.bindDocument(new QName("document"), document, null, null);
			XQResultSequence result = expr.executeQuery();

			Properties props = new Properties();
			props.setProperty(OutputKeys.METHOD, "xml");
			props.setProperty(OutputKeys.INDENT, "yes");

			File output = new File(cmdifile.getAbsolutePath() + ".dc");
			BufferedOutputStream outputStream = new BufferedOutputStream(new FileOutputStream(output));
			result.writeSequence(outputStream, props);
			return output;
		}
	}
}
