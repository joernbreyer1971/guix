(use-modules (gnu)
             (gnu system)
             (gnu services networking)
             (gnu services desktop)
             (gnu services virtualization)
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

  ;; Nonguix Kernel für Intel WLAN & Hardware-Kompatibilität
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))

  ;; Dateisysteme & Partitionen (Exakt deine UUIDs vom Lenovo M900z)
  (file-systems (cons* (file-system
                         (mount-point "/")
                         (device (uuid "0074c533-7b02-4afe-8417-3e0ce2ae6b9d" 'ext4))
                         (type "ext4"))
                       (file-system
                         (mount-point "/home")
                         (device (uuid "35e2456f-34ca-4f99-8aec-a3f0c888217a" 'ext4))
                         (type "ext4"))
                       (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "7E50-D66A" 'fat32))
                         (type "vfat"))
                       %base-file-systems))

  ;; Swap-Partition
  (swap-devices (list (swap-space
                        (target (uuid "5a41ea9f-268c-4a4e-a030-d636aa47fbfc")))))

  ;; Benutzer & Gruppen
  (users (cons (user-account
                 (name "jay")
                 (group "users")
                 (supplementary-groups '("wheel" "netdev" "audio" "video" "kvm" "libvirt" "cdrom")))
               %base-user-accounts))

  ;; Software-Pakete
  (packages (append (list
                     ;; Wayland / Sway Stack
                     sway waybar alacritty wofi swaybg grim slurp
                     ;; Office, Grafik & Multimedia
                     firefox chromium libreoffice geany krita audacity asunder okular celluloid
                     ;; System & Utilities
                     git tmux unzip wget yt-dlp fastfetch
                     )
                    %base-packages))

  ;; Systemdienste
  (services (append (list
                     (service network-manager-service-type)
                     (service bluetooth-service-type)
                     (service libvirt-service-type))
                    %desktop-services)))
