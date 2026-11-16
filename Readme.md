# Linux Kernel Dev Environment

Setup a working dev environment for Linux Kernel with Rust.

> [!NOTE]
> This setup is tested only on x86_64 arch

## Prerequisites

- `qemu-system-x86_64`
- `just`
- `wget`
- `rust`: Make sure you follow this [quick start guide](https://docs.kernel.org/rust/quick-start.html) first

## Kernel

1. Clone the kernel source code

```
git clone https://github.com/Rust-for-Linux/linux.git
```

2. Use a minimalist config

```
cp assets/dev.config linux/kernel/configs/
```

3. Copy Lapoisse module

```
cp -r assets/lapoisse linux/drivers/misc
```

4. Add this line to the makefile `linux/drivers/misc/Makefile`

```
obj-$(CONFIG_LAPOISSE)          += lapoisse/
```

5. Add this to the Kconfig `linux/drivers/misc/Kconfig`

```
source "drivers/misc/lapoisse/Kconfig"
```

6. Enable the config

```
cd linux
make LLVM=1 allnoconfig dev.config
```

7. Then compile

```
make LLVM=1 -j
```

## Initramfs

Run this command to build the initramfs

```
just initramfs
```

this should produce `initramfs.img` in the current directory

## Boot up

Now that everthing is built, run this to boot up

```
just run
```

and you should land in a shell with this message in the boot logs

```
[    0.401298] lapoisse: ***** Caporal Lapoisse au rapport ! *****
```

# Resources

- https://docs.kernel.org/rust/quick-start.html
- https://github.com/wedsonaf/linux/blob/542379556669fee413ad45bc9611187e075b0d47/kernel/configs/qemu-busybox-min.config
- https://www.youtube.com/watch?v=tPs1uRqOnlk

# License

GPLv3
