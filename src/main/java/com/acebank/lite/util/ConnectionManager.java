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

    private static Connection connection;
    private static boolean isSchemaInitialized = false;
    static final Logger log = Logger.getLogger(ConnectionManager.class.getName());

    private ConnectionManager() {
    }

    public static synchronized Connection getConnection() throws SQLException {
        // 1. Check if the connection is dead/null
        if (connection == null || connection.isClosed()) {
            establishConnection();
        }

        // 2. Run the script ONLY ONCE on the very first successful connection
        if (connection != null && !isSchemaInitialized) {
            String scriptPath = ConfigLoader.getProperty(ConfigKeys.DB_SCRIPT_PATH);
            if (scriptPath != null) {
                runInitScript(scriptPath);
            }
            isSchemaInitialized = true; // Set flag so it never runs again
        }

        return connection;
    }

    private static void establishConnection() throws SQLException {
        try {
            String url = ConfigLoader.getProperty(ConfigKeys.DB_URL);
            String user = ConfigLoader.getProperty(ConfigKeys.DB_USER);
            String pass = ConfigLoader.getProperty(ConfigKeys.DB_PWD);
            String driverName = ConfigLoader.getProperty(ConfigKeys.DB_MYSQL_DRIVER);

            Class.forName(driverName);// VVI
            connection = DriverManager.getConnection(url, user, pass);
            log.info("Database connection established.");
        } catch (Exception e) {
            log.severe("Database Connection Failed: " + e.getMessage());
            throw new SQLException("Failed to establish database connection", e);
        }
    }

    private static void runInitScript(String path) {
        String normalizedPath = path.startsWith("/") ? path : "/" + path;
        try (InputStream is = ConnectionManager.class.getResourceAsStream(normalizedPath)) {
            if (is == null) {
                log.warning("Script not found at: " + normalizedPath);
                return;
            }
            ScriptRunner runner = new ScriptRunner(connection);
            runner.setLogWriter(null);
            runner.setStopOnError(false);
            runner.runScript(new BufferedReader(new InputStreamReader(is)));
            log.info("SQL Schema checked/initialized.");
        } catch (Exception e) {
            log.severe("SQL Init Error: " + e.getMessage());
        }
    }
}