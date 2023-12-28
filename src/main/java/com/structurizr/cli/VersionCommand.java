package com.structurizr.cli;

import com.structurizr.Workspace;
import com.structurizr.dsl.StructurizrDslParser;
import com.structurizr.export.plantuml.StructurizrPlantUMLExporter;
import com.structurizr.importer.documentation.DefaultDocumentationImporter;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

class VersionCommand extends AbstractCommand {

    private static final Log log = LogFactory.getLog(VersionCommand.class);

    VersionCommand() {
    }

    public void run(String... args) throws Exception {
        String version = getClass().getPackage().getImplementationVersion();
        log.info("structurizr-cli: " + version);

        try {
            log.info("structurizr-java: " + Class.forName(Workspace.class.getCanonicalName()).getPackage().getImplementationVersion());
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            log.info("structurizr-dsl: " + Class.forName(StructurizrDslParser.class.getCanonicalName()).getPackage().getImplementationVersion());
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            log.info("structurizr-export: " + Class.forName(StructurizrPlantUMLExporter.class.getCanonicalName()).getPackage().getImplementationVersion());
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            log.info("structurizr-import: v" + Class.forName(DefaultDocumentationImporter.class.getCanonicalName()).getPackage().getImplementationVersion());
        } catch (Exception e) {
            e.printStackTrace();
        }

        log.info("Java: " + System.getProperty("java.version") + "/"  + System.getProperty("java.vendor") + " (" + System.getProperty("java.home") + ")");
        log.info("OS: " + System.getProperty("os.name") + " "  + System.getProperty("os.version") + " (" + System.getProperty("os.arch") + ")");
    }

}