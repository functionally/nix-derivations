{ config, pkgs, ... }:

{

  imports = [
    <nixpkgs/nixos/modules/virtualisation/google-compute-image.nix>
    ./system-packages.nix
    ./users-groups.nix
  ];

  nixpkgs.config.allowUnfree = true;

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward"                = true;
    "net.ipv4.conf.all.forwarding"       = true;
    "net.ipv4.conf.all.accept_redirects" = false;
    "net.ipv4.conf.all.send_redirects"   = false;
  };

  networking = {
    firewall = {
      enable = true;
      extraCommands = ''
      # iptables -I INPUT -s 10.128.0.0/9 -j ACCEPT

        iptables -I INPUT -s 71.218.106.183  -j nixos-fw-accept # home
        iptables -I INPUT -s 104.198.152.159 -j nixos-fw-accept # brianwbush.info

        iptables -I INPUT -p tcp --dport  2181 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # zookeeper
        iptables -I INPUT -p tcp --dport  4001 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # ipfs
        iptables -I INPUT -p tcp --dport  5050 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # textile gateway
        iptables -I INPUT -p tcp --dport  5432 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # postgresql
        iptables -I INPUT -p tcp --dport  5820 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # stardog
        iptables -I INPUT -p tcp --dport  9092 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # kafka
        iptables -I INPUT -p tcp --dport 10022 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # ssh
        iptables -I INPUT -p tcp --dport 14348 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # textile swarm
        iptables -I INPUT -p tcp --dport 19429 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # textile swarm
        iptables -I INPUT -p tcp --dport 27017 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # mongodb
        iptables -I INPUT -p tcp --dport 27663 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # textile swarm
        iptables -I INPUT -p tcp --dport 32749 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # gridcoinresearchd
        iptables -I INPUT -p tcp --dport 40601 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # textile cafe
        iptables -I INPUT -p tcp --dport 42042 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # infovis

        iptables -I FORWARD -s 172.31.42.0/23 -d 172.31.42.0/23 -j DROP

      # openvpn
        iptables        -I INPUT       -i eth0         -m state --state NEW                 -p udp --dport 1194 -j ACCEPT
        iptables        -I INPUT       -i tun+                                                                  -j ACCEPT
        iptables        -I FORWARD     -i tun+                                                                  -j ACCEPT
        iptables        -I FORWARD     -i tun+ -o eth0 -m state --state RELATED,ESTABLISHED                     -j ACCEPT
        iptables        -I FORWARD     -i eth0 -o tun+ -m state --state RELATED,ESTABLISHED                     -j ACCEPT
        iptables -t nat -I POSTROUTING         -o eth0                                      -s 172.31.43.0/24   -j MASQUERADE

        # ipsec-nat
        iptables           -I INPUT       -p udp --dport  500                                                          -j ACCEPT
        iptables           -I INPUT       -p udp --dport 4500                                                          -j ACCEPT
        iptables           -I INPUT       -p esp                                                                       -j ACCEPT
        iptables           -I INPUT       -p ah                                                                        -j ACCEPT
      # iptables           -I INPUT       -p ipencap        -m policy    --dir in  --pol ipsec --proto esp             -j ACCEPT
        iptables -t nat    -I POSTROUTING -s 172.31.42.0/24 -m policy    --dir out --pol none                          -j MASQUERADE
      # iptables -t mangle -I FORWARD     -s 172.31.42.0/24 -m tcp       -p tcp --tcp-flags SYN,RST SYN --set-mss 1316 -j TCPMSS
        iptables           -I FORWARD     -s 172.31.42.0/24 -m conntrack --ctstate NEW -m policy --dir in  --pol ipsec -j ACCEPT
      '';
    };
  };

  services = {

    openssh = {
      enable = true;
      allowSFTP = false;
      extraConfig = ''
        HostCertificate   /etc/ssh/ssh_host_rsa_key-cert.pub
        HostCertificate   /etc/ssh/ssh_host_ed25519_key-cert.pub
        TrustedUserCAKeys /etc/ssh/brianwbush-ca.pub
      '';
      ports = [ 22 443 ];
    };


    openvpn.servers = {
      brianwbush = {
        config = ''
          plugin /run/current-system/sw/lib/openvpn/plugins/openvpn-plugin-auth-pam.so login
          port 1194
          proto udp
          dev tun
          ca   /etc/nixos/easyrsa/pki/ca.crt
          cert /etc/nixos/easyrsa/pki/issued/vpn.brianwbush.info.crt.orig
          key  /etc/nixos/easyrsa/pki/private/vpn.brianwbush.info.key
          dh   /etc/nixos/easyrsa/pki/dh.pem
          push "redirect-gateway def1"
        # push "redirect-gateway def1 disable-dhcp"
        # push "redirect-gateway def1 disable-dns"
        # push "redirect-gateway def1 disable-dhcp disable-dns"
        # push "redirect-gateway autolocal"
          push "dhcp-option DNS 8.8.8.8"
          push "dhcp-option DNS 8.8.4.4"
          keepalive 10 120
        # comp-lzo
          user  nobody
          group nogroup
          server 172.31.43.0 255.255.255.0
          ifconfig-pool-persist /etc/nixos/openvpn-ipp.txt
          persist-key
          persist-tun
          status /etc/nixos/openvpn-status.log
          verb 3
        '';
        autoStart = false;
        updateResolvConf = false;
      };
    };

    strongswan = {
      enable = true;
      setup = {
        uniqueids = "never";
        charondebug ="ike 1, knl 1, cfg 1, net 1, esp 1, dmn 1, mgr 1";
      };
      ca = {
        brianwbush = {
          auto = "add";
          cacert = "/etc/nixos/easyrsa/pki/ca.crt";
        };
      };
      connections = {
        vpn-brianwbush = {
          fragmentation = "yes";
          rekey         = "no";
          dpdaction     = "clear";
          compress      = "yes";
          dpddelay      = "35s";
          left          = "%any";
          right         = "%any";
          auto          = "add";
          keyexchange   = "ikev2";
          ike           = "aes128gcm16-sha2_512-prfsha512-ecp256,aes128-sha2_512-prfsha512-ecp256,aes128-sha2_256-prfsha256-modp2048!";
          esp           = "aes128gcm16-sha2_512-ecp256,aes128-sha2_512-ecp256,aes128-sha2_256-modp2048!";
          leftauth      = "pubkey";
          leftid        = "104.198.152.159";
          leftcert      = "/etc/nixos/easyrsa/pki/issued/vpn.brianwbush.info.crt";
          leftsendcert  = "always";
          leftsubnet    = "0.0.0.0/0";
          rightauth     = "pubkey";
          rightsourceip = "172.31.42.0/24";
          rightdns      = "8.8.8.8,8.8.4.4";
        };
      };
      secrets = [
        "/etc/nixos/ipsec.secrets"
      ];
    };

  };

  time.timeZone = "America/Denver";

  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
  programs = {
    bash.enableCompletion = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

}
