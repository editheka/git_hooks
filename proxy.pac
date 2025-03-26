function FindProxyForURL(url, host) {
    // Convert host to lowercase for consistency
    host = host.toLowerCase();

    // If the domain is exactly 'yahoo.com' or any subdomain of '.yahoo.com'
    if (dnsDomainIs(host, "yahoo.com") || dnsDomainIs(host, ".yahoo.com")) {
        // Send traffic directly (no proxy)
        return "DIRECT";
    }

    // Otherwise, attempt to connect via a non-existent proxy, effectively blocking
    return "PROXY 127.0.0.1:9";
}
