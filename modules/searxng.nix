{ config, pkgs, ... }:

{
  # 1. Enable SearXNG Service
  services.searx = {
    enable = true;
    # Ensure it uses the modern searxng package instead of legacy searx
    package = pkgs.searxng;
    
    # Load the secret key securely at runtime
    environmentFile = "/var/lib/searxng/searxng.env";

    # Enable a local Redis instance for caching and rate-limiting
    redisCreateLocally = true;

    # Run inside uWSGI (recommended for performance behind a reverse proxy)
    runInUwsgi = true;
    uwsgiConfig = {
      socket = "/run/searx/searx.sock";
      chmod-socket = "660";
    };

    # Application settings (maps directly to SearXNG's settings.yml)
    settings = {
      instance = {
        name = "My Private SearXNG";
      };

      server = {
        # Base URL must match your reverse proxy domain
        base_url = "https://search.example.com/";
        port = 8888;
        bind_address = "127.0.0.1";
        secret_key = "@SEARXNG_SECRET@"; # Interpolated from environmentFile
        limiter = true; # Enable built-in rate-limiting
        image_proxy = true; # Proxy images to avoid leaking user IP addresses
      };

      ui = {
        static_use_hash = true;
        theme_args.simple_style = "auto"; # Supports light/dark mode automatically
      };

      search = {
        safe_search = 0; # 0 = None, 1 = Moderate, 2 = Strict
        autocomplete = "duckduckgo";
      };

      # Configure your preferred search backends
      engines = [
        { name = "google"; disabled = false; }
        { name = "duckduckgo"; disabled = false; }
        { name = "wikipedia"; disabled = false; }
        { name = "bing"; disabled = true; } # Disabled by default
      ];
    };
  };

  # 2. Configure Nginx Reverse Proxy
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."search.example.com" = {
      enableACME = true; # Handles automatic Let's Encrypt SSL certificates
      forceSSL = true;

      # Route traffic natively through the uWSGI UNIX socket
      locations."/" = {
        extraConfig = ''
          uwsgi_pass unix:/run/searx/searx.sock;
          include ${pkgs.nginx}/conf/uwsgi_params;
        '';
      };
    };
  };

  # 3. Add Nginx to the SearXNG group to read the uWSGI socket file
  users.groups.searx.members = [ "nginx" ];

  # 4. Open HTTP/HTTPS Firewall Ports
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
