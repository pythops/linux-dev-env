default:
    @just --list

clean:
    rm -rf initramfs
    rm -rf initramfs.img

initramfs:
    #!/bin/bash
    set -e
    # Download busybox binary
    if [ ! -f "busybox" ]; then
        wget https://www.busybox.net/downloads/binaries/1.35.0-x86_64-linux-musl/busybox
    fi
    mkdir -p initramfs/{bin,sbin,etc,proc,sys,dev,run,tmp}
    cp busybox initramfs/bin/busybox
    cp assets/inittab initramfs/etc/inittab
    chmod +x initramfs/bin/busybox
    cd initramfs
    bin/busybox --install ./bin
    cd ..
    cat <<EOF  > initramfs/init
    #!/bin/sh
    /bin/mount -t devtmpfs devtmpfs /dev
    /bin/mount -t proc proc /proc
    /bin/mount -t sysfs sysfs /sys
    exec setsid cttyhack /bin/busybox init
    EOF
    chmod +x initramfs/init
    cd initramfs; /usr/bin/find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../initramfs.img


run:
    qemu-system-x86_64 \
        -kernel linux/arch/x86/boot/bzImage \
        -initrd initramfs.img \
        -append "console=ttyS0" \
        -nographic
