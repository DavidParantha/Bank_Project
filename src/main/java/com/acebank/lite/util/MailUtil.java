package com.acebank.lite.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import lombok.extern.java.Log;

import java.util.Properties;
import java.util.concurrent.CompletableFuture;

@Log
public class MailUtil {

    public static void sendMailAsync(String recipient, String subject, String body) {
        log.info("Scheduling background email to: " + recipient);
        CompletableFuture.runAsync(() -> {
            try {
                sendMail(recipient, subject, body);
            } catch (Exception e) {
                log.warning("Background email failed for " + recipient + ": " + e.getMessage());
                e.printStackTrace();
            }
        });
    }

    public static boolean sendMail(final String recipient, String subject, String body) {
        log.info("Attempting to send email to: " + recipient);

        String mailAddr = ConfigLoader.getProperty(ConfigKeys.MAIL_ADDR);
        String mailPwd = ConfigLoader.getProperty(ConfigKeys.MAIL_PWD);

        if (mailAddr == null || mailPwd == null || mailAddr.isEmpty() || mailPwd.isEmpty()) {
            log.severe("Email credentials are not configured! MAIL_ADDR: " + mailAddr + ", PWD provided: "
                    + (mailPwd != null && !mailPwd.isEmpty()));
            return false;
        }

        try {
            Properties props = getSmtpConfig();
            log.info("SMTP Config: " + props.toString());

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(mailAddr, mailPwd);
                }
            });

            // Enable debugging if needed
// session.setDebug(true);

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(mailAddr, "AceBank Support"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
            message.setSubject(subject);
            message.setText(body);

            log.info("Handing off to Transport.send...");
            Transport.send(message);
            log.info("Email sent successfully to " + recipient);
            return true;

        } catch (Exception e) {
            log.severe("Failed to send email to " + recipient + ". Error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private static Properties getSmtpConfig() {
        Properties props = new Properties();

        // Mapping keys from ConfigKeys to the Properties object
        props.put("mail.smtp.host", ConfigLoader.getProperty(ConfigKeys.MAIL_SMTP_HOST));
        props.put("mail.smtp.port", ConfigLoader.getProperty(ConfigKeys.MAIL_SMTP_PORT));
        props.put("mail.smtp.auth", ConfigLoader.getProperty(ConfigKeys.MAIL_SMTP_AUTH));
        props.put("mail.smtp.starttls.enable", ConfigLoader.getProperty(ConfigKeys.MAIL_SMTP_STARTTLS));
        props.put("mail.smtp.connectiontimeout", ConfigLoader.getProperty(ConfigKeys.MAIL_SMTP_CONN_TIMEOUT));
        props.put("mail.smtp.timeout", ConfigLoader.getProperty(ConfigKeys.MAIL_SMTP_TIMEOUT));

        // Fallback defaults if above are null
        if (props.getProperty("mail.smtp.host") == null)
            props.put("mail.smtp.host", "smtp.gmail.com");
        if (props.getProperty("mail.smtp.port") == null)
            props.put("mail.smtp.port", "587");
        if (props.getProperty("mail.smtp.auth") == null)
            props.put("mail.smtp.auth", "true");
        if (props.getProperty("mail.smtp.starttls.enable") == null)
            props.put("mail.smtp.starttls.enable", "true");

        return props;
    }
}