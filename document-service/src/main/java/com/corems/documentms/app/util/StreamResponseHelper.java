package com.corems.documentms.app.util;

import com.corems.documentms.app.config.DocumentConfig;
import com.corems.documentms.app.model.DocumentStreamResult;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;

import java.io.BufferedInputStream;
import java.nio.charset.StandardCharsets;

public final class StreamResponseHelper {

    private StreamResponseHelper() {
    }

    public static ResponseEntity<Resource> buildStreamResponse(DocumentStreamResult streamResult,
                                                               DocumentConfig documentConfig,
                                                               String dispositionType) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType(
                streamResult.getContentType() != null ? streamResult.getContentType() : "application/octet-stream"));
        
        if (streamResult.getSize() != null && streamResult.getSize() > 0) {
            headers.setContentLength(streamResult.getSize());
        }
        
        headers.setContentDisposition(ContentDisposition.builder(dispositionType)
                .filename(streamResult.getFilename(), StandardCharsets.UTF_8)
                .build());
        headers.setCacheControl("no-cache, no-store, must-revalidate");
        headers.setPragma("no-cache");
        headers.setExpires(0);

        int bufferSize = documentConfig != null && documentConfig.getStream() != null
                ? documentConfig.getStream().getBufferSize()
                : 8192;

        InputStreamResource resource = new InputStreamResource(
            new BufferedInputStream(streamResult.getStream(), bufferSize)
        );

        return ResponseEntity.ok()
                .headers(headers)
                .body(resource);
    }
}
