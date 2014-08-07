package de.tuebingen.uni.sfs.cmdi2dc;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.xml.xquery.XQException;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

/**
 *
 * @author edima
 */
@Produces(MediaType.APPLICATION_JSON)
@Path("/")
public class Service {

	@Context
	HttpServletRequest request;
	@Context
	HttpServletResponse response;

	@GET
	@Path("{id}")
	@Consumes(MediaType.MULTIPART_FORM_DATA)
	public Response getFile(@PathParam("id") String id) throws IOException {
		File f = new File(SessionTmpDir.getSessionDir(request.getSession()), id);
		if (!f.exists()) {
			return Response.status(404).entity("File not found").build();
		}
		return Response.ok().entity(f).build();
	}

	public static class FileEntry {

		public final String name;
		public final File file;

		public FileEntry(String name, File file) {
			this.name = name;
			this.file = file;
		}
	}

	public static List<FileEntry> extractFiles(HttpServletRequest request) throws Exception {
		List<FileEntry> files = new ArrayList<>();
		if (ServletFileUpload.isMultipartContent(request)) {
			FileItemFactory factory = new DiskFileItemFactory();
			ServletFileUpload upload = new ServletFileUpload(factory);
			for (Object item : upload.parseRequest(request)) {
				if (item instanceof FileItem) {
					FileItem fi = (FileItem) item;
					if (!fi.isFormField()) { // it's a file
						File f = SessionTmpDir.newNamedFile(request.getSession(), fi.getName());
						fi.write(f);
						files.add(new FileEntry(fi.getName(), f));
					}
				}
			}
		}
		return files;
	}

	@POST
	@Consumes(MediaType.MULTIPART_FORM_DATA)
	@Produces(MediaType.APPLICATION_JSON)
	public Response getDublinCore() throws IOException {
		try {
			if (!ServletFileUpload.isMultipartContent(request)) {
				return Response.status(400).entity("Multipart content expected, and this is not").build();
			}

			List<FileEntry> files = extractFiles(request);
			Map<String, String> results = new HashMap<>();
			if (files.isEmpty()) {
				return Response.status(400).entity("No file!").build();
			}
			for (FileEntry fileEntry : files) {
//				File result = fileEntry.file;
				File result = CMDICast.castFile(fileEntry.file);
				results.put(result.getName(), "rest/" + result.getName());
			}
			return Response.ok().entity(results).build();
		} catch (FileNotFoundException xc) {
			return Response.status(404).entity(xc.toString()).build();
		} catch (XQException xc) {
			return Response.status(400).entity(xc.toString()).build();
		} catch (Exception xc) {
			return Response.status(500).entity(xc.toString()).build();
		}
	}
}
