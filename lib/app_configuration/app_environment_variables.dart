class AppEnvironmentVariables{
  static const baseURL = "base-url";
  static const baseWebURL = "base-web-url";
  static const appName = "app-name";
  static const appTitle = "app-title";
  static const debugBannerBoolean = "debug-banner-boolean";
  static const iOSBundleID = "iOSBundleID";

  //make necessary changes
  static Map<String, dynamic> dev = {
    baseURL: "https://server.buildupyourvoice.com/byv/",
    baseWebURL: "https://vitec-dev.com",
    appName:'Amsel Dev',
    debugBannerBoolean: false,
    appTitle: 'Amsel Dev',
    iOSBundleID: 'org.fuhs.buildyourvoice.dev'
  };

  //make necessary changes
  static Map<String, dynamic> prod = {
    baseURL: "https://server.buildupyourvoice.com/byv/",
    baseWebURL: "https://vitec-prod.com",
    appName:'Amsel',
    debugBannerBoolean: false,
    appTitle: 'Amsel',
    iOSBundleID: 'org.fuhs.buildyourvoice'
  };
}