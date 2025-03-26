function FindProxyForURL(url, host) {
    if (dnsDomainIs(host, "*yahoo.com")) {
        return "DIRECT"; // Connessione diretta per Yahoo
    }
    return "proxy.example.com:8080"; // Proxy per altri siti
}
