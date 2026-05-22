package com.acebank.lite.util;

import org.apache.ibatis.jdbc.ScriptRunner;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Logger;

//@Log
public final class ConnectionManager {

    private static boolean isSchemaInitialized = false;
    static final Logger log = Logger.getLogger(ConnectionManager.class.getName());

    private ConnectionManager() {
    }

    public static Connection getConnection() throws SQLException {
        Connection conn = establishConnection();

        // 2. Run the script ONLY ONCE on the very first successful connection
        if (!isSchemaInitialized) {
            synchronized (ConnectionManager.class) {
                if (!isSchemaInitialized) {
                    String scriptPath = ConfigLoader.getProperty(ConfigKeys.DB_SCRIPT_PATH);
                    if (scriptPath != null) {
                        try (Connection initConn = establishConnection()) {
                            runInitScript(initConn, scriptPath);
                        } catch (Exception e) {
                            log.severe("Failed to run init script: " + e.getMessage());
                        }
                    }
                    isSchemaInitialized = true; // Set flag so it never runs again
                }
            }
        }

        return conn;
    }

    private static Connection establishConnection() throws SQLException {
        try {
            String url = ConfigLoader.getProperty(ConfigKeys.DB_URL);
            String user = ConfigLoader.getProperty(ConfigKeys.DB_USER);
            String pass = ConfigLoader.getProperty(ConfigKeys.DB_PWD);
            String driverName = ConfigLoader.getProperty(ConfigKeys.DB_MYSQL_DRIVER);

            Class.forName(driverName);// VVI
            Connection conn = DriverManager.getConnection(url, user, pass);
            log.info("Database connection established.");
            return conn;
        } catch (Exception e) {
            log.severe("Database Connection Failed: " + e.getMessage());
            throw new SQLException("Failed to establish database connection", e);
        }
    }

    private static void runInitScript(Connection conn, String path) {
        String normalizedPath = path.startsWith("/") ? path.substring(1) : path;
        
        // Try multiple ways to load the file
        InputStream is = Thread.currentThread().getContextClassLoader().getResourceAsStream(normalizedPath);
        if (is == null) {
            is = ConnectionManager.class.getResourceAsStream("/" + normalizedPath);
        }
        
        if (is == null) {
            log.severe("CRITICAL: Script not found at: " + normalizedPath + " or /" + normalizedPath);
            return;
        }
        
        try {
            ScriptRunner runner = new ScriptRunner(conn);
            runner.setLogWriter(null);
            runner.setStopOnError(true); // Fail loudly if script has syntax errors
            runner.runScript(new BufferedReader(new InputStreamReader(is)));
            log.info("SQL Schema successfully initialized.");
        } catch (Exception e) {
            log.severe("SQL Init Error: " + e.getMessage());
        } finally {
            try { is.close(); } catch (Exception e) {}
        }
    }
}