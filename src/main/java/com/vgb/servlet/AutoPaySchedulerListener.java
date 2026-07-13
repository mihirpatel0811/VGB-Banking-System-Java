package com.vgb.servlet;

import com.vgb.service.AutoPayService;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@WebListener
public class AutoPaySchedulerListener implements ServletContextListener {
    private static final Logger logger = LoggerFactory.getLogger(AutoPaySchedulerListener.class);
    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        logger.info("Initializing VGB AutoPay Background Scheduler Task...");
        scheduler = Executors.newSingleThreadScheduledExecutor();
        // Run daily checks (every 24 hours), starting 2 minutes after application deployment
        scheduler.scheduleAtFixedRate(() -> {
            try {
                logger.info("AutoPay Scheduler: Starting daily processing checks...");
                AutoPayService autoPayService = new AutoPayService();
                int processed = autoPayService.processAutoPayments();
                logger.info("AutoPay Scheduler: Run finished. Processed {} transactions.", processed);
            } catch (Exception e) {
                logger.error("AutoPay Scheduler encountered runtime processing error", e);
            }
        }, 2, 1440, TimeUnit.MINUTES);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        logger.info("Stopping VGB AutoPay Background Scheduler Task...");
        if (scheduler != null) {
            scheduler.shutdown();
            try {
                if (!scheduler.awaitTermination(5, TimeUnit.SECONDS)) {
                    scheduler.shutdownNow();
                }
            } catch (InterruptedException e) {
                scheduler.shutdownNow();
                Thread.currentThread().interrupt();
            }
        }
        logger.info("VGB AutoPay Background Scheduler Task stopped cleanly.");
    }
}
