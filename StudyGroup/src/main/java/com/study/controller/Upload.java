package com.study.controller;

import java.io.File;
import java.io.IOException;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class Upload {
	
	public String fileUplaod(MultipartFile mFile, String path) {
		
		String file_name = "";
		String uploadPath = path;
		
		String originalFileName = mFile.getOriginalFilename();
		
		String saveFileName = originalFileName;
		
		if(saveFileName != null && !saveFileName.equals("")) {
			saveFileName = System.currentTimeMillis() + "_" + saveFileName;
			
			try {
				mFile.transferTo(new File(uploadPath + saveFileName));
				file_name =  saveFileName;
			} catch (IllegalStateException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		return file_name;
	}
}
