package com.vgb.servlet;

import com.vgb.constants.AppConstants;
import com.vgb.service.CustomerService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;

/**
 * UploadProfileServlet: Handles profile avatar uploads
 */
@WebServlet(name = "UploadProfileServlet", value = "/upload-profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class UploadProfileServlet extends BaseServlet {
    private CustomerService customerService = new CustomerService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(AppConstants.USER_SESSION_KEY) == null) {
            String acceptHeader = request.getHeader("Accept");
            boolean isAjax = (acceptHeader != null && acceptHeader.contains("application/json")) || 
                             "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
            if (isAjax) {
                sendErrorResponse(response, "Unauthorized access. Please login.", HttpServletResponse.SC_UNAUTHORIZED);
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
            return;
        }

        Long customerId = getUserId(request);
        String acceptHeader = request.getHeader("Accept");
        boolean isAjax = (acceptHeader != null && acceptHeader.contains("application/json")) || 
                         "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
        
        try {
            Part filePart = request.getPart("avatarFile");
            if (filePart == null || filePart.getSize() == 0) {
                if (isAjax) {
                    sendErrorResponse(response, "Please select a valid image file to upload.", HttpServletResponse.SC_BAD_REQUEST);
                } else {
                    session.setAttribute("error", "Please select a valid image file to upload.");
                    response.sendRedirect(request.getContextPath() + "/customer/proflie.jsp");
                }
                return;
            }

            // Verify content type
            String contentType = filePart.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                if (isAjax) {
                    sendErrorResponse(response, "Only image files (JPEG, PNG, GIF) are allowed.", HttpServletResponse.SC_BAD_REQUEST);
                } else {
                    session.setAttribute("error", "Only image files (JPEG, PNG, GIF) are allowed.");
                    response.sendRedirect(request.getContextPath() + "/customer/proflie.jsp");
                }
                return;
            }

            // Define directory
            String uploadPath = request.getServletContext().getRealPath("/assest/img/avatars/");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Generate safe, unique file name using strictly whitelisted extensions
            String originalName = getSubmittedFileName(filePart);
            if (originalName == null) {
                originalName = "avatar.png";
            }
            
            // Extract leaf name only, removing any directory components or path traversal sequences
            originalName = new File(originalName).getName();
            
            String ext = "png";
            if (originalName.contains(".")) {
                String potentialExt = originalName.substring(originalName.lastIndexOf(".") + 1).toLowerCase().trim();
                // Strict alphanumeric whitelisting to only allow safe image extensions, preventing traversal or malicious file execution
                if (potentialExt.matches("^[a-zA-Z0-9]+$") && 
                    (potentialExt.equals("png") || potentialExt.equals("jpg") || potentialExt.equals("jpeg") || potentialExt.equals("gif"))) {
                    ext = potentialExt;
                }
            }

            String fileName = "avatar_" + customerId + "_" + System.currentTimeMillis() + "." + ext;
            String filePath = uploadPath + File.separator + fileName;
            
            // Save file
            filePart.write(filePath);
            
            // Also copy to workspace source directory so uploaded avatar persists across server restarts
            try {
                String sourceDirPath = "d:/InternShip Project/VGB-Banking-System-Java/src/main/webapp/assest/img/avatars/";
                File sourceDir = new File(sourceDirPath);
                if (!sourceDir.exists()) {
                    sourceDir.mkdirs();
                }
                File sourceFile = new File(sourceDir, fileName);
                java.nio.file.Files.copy(new File(filePath).toPath(), sourceFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
            } catch (Exception ex) {
                logger.warn("Could not copy uploaded avatar to source folder", ex);
            }

            // Update in database
            String relativePath = "/assest/img/avatars/" + fileName;
            customerService.updateCustomerAvatar(customerId, relativePath);
            
            // Update session customer if present
            Object customerObj = request.getAttribute("customer");
            if (customerObj instanceof com.vgb.model.Customer) {
                ((com.vgb.model.Customer) customerObj).setAvatarPath(relativePath);
            }
            
            if (isAjax) {
                java.util.Map<String, Object> data = new java.util.HashMap<>();
                data.put("success", true);
                data.put("message", "Profile picture uploaded and updated successfully!");
                data.put("avatarPath", relativePath);
                sendJsonResponse(response, data, HttpServletResponse.SC_OK);
            } else {
                session.setAttribute("success", "Profile picture uploaded and updated successfully!");
                response.sendRedirect(request.getContextPath() + "/customer/proflie.jsp");
            }
            
        } catch (Exception e) {
            logger.error("Failed to upload profile picture", e);
            if (isAjax) {
                sendErrorResponse(response, "Error uploading profile picture: " + e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            } else {
                session.setAttribute("error", "Error uploading profile picture: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/customer/proflie.jsp");
            }
        }
    }

    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "default.png";
    }
}
