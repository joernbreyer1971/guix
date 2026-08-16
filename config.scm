(use-modules (gnu)
             (gnu system)
             (gnu services)
             (gnu services desktop)
             (gnu services networking)
             (gnu services virtualization)
             (gnu packages)
             (nongnu packages linux)
             (nongnu system linux-initrd))

(operating-system
  (host-name "erebos")
  (timezone "Europe/Berlin")
  (locale "de_DE.utf8")

  ;; Bootloader (UEFI)
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets '("/boot/efi"))))

  ;; Nonguix Kernel
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))

  ;; Dateisysteme (exakt deine UUIDs)
  (file-systems (cons* (file-system
                         (mount-point "/")
                         (device (uuid "b6184e90-d9b4-45a6-bd72-6a9cea2ff5d0"))
                         (type "ext4"))
                       (file-system
                         (mount-point "/home")
                         (device (uuid "35e2456f-34ca-4f99-8aec-a3f0c888217a"))
                         (type "ext4"))
                       (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "7E50-D66A" 'fat32))
                         (type "vfat"))
                       %base-file-systems))

  ;; Swap
  (swap-devices (list (swap-space
                        (target (uuid "5a41ea9f-268c-4a4e-a030-d636aa47fbfc")))))

  ;; Benutzer
  (users (cons (user-account
                 (name "jay")
                 (group "users")
                 (supplementary-groups '("wheel" "netdev" "audio" "video" "kvm" "libvirt" "cdrom")))
               %base-user-accounts))

  ;; Pakete via string-lookup (verhindert 'unbound variable' Fehler)
  (packages (append (map specification->package
                         '("sway" "waybar" "alacritty" "wofi" "swaybg" "grim" "slurp"
                           "firefox" "libreoffice" "geany" "krita" "audacity" "asunder" "okular" "celluloid"
                           "git" "tmux" "unzip" "wget" "yt-dlp" "fastfetch"))
                    %base-packages))

  ;; Dienste (ohne doppelte Einträge)
  (services (append (list
                     (service bluetooth-service-type)
                     (service libvirt-service-type))
                    %desktop-services)))
