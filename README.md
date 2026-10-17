# biglinux-livecd-key

Ready-made pacman keyring for the BigLinux **live ISO**.

> **Do not install this package on an installed system.** It replaces the
> pacman keyring in `/etc/pacman.d/gnupg/`. It exists only for the ISO build.

A live system boots with an empty pacman keyring, and filling it with
`pacman-key --init` and `pacman-key --populate` takes time on every boot. This
package ships the keyring already populated (`pubring.gpg` and `trustdb.gpg`)
with the Arch Linux, Manjaro and BigLinux keys, so pacman can verify packages
right away in the live session.

## What it installs

| File | Purpose |
|---|---|
| `/usr/share/pacman/keyrings/pubring.gpg` | public keys (Arch Linux, Manjaro, BigLinux) |
| `/usr/share/pacman/keyrings/trustdb.gpg` | trust database for those keys |
| `/usr/bin/biglinux-livecd-key.sh` | copies both files to `/etc/pacman.d/gnupg/` and runs `pacman-key --init` |
| `/usr/lib/systemd/system/biglinux-livecd-key.service` | runs the script at boot, after `pacman-init.service` |

The package's install script does the same copy when the package is installed
or upgraded inside the ISO.

## Keys

The BigLinux keys come from
[biglinux-keyring](https://github.com/biglinux/biglinux-keyring): the current
signing key `F7EB9C2849EFFEFF05789738047C6A782618D2CA` and the previous ones,
which still sign older packages.

## Updates

The [BigLinux Update Key](.github/workflows/update-key.yml) workflow rebuilds
the keyring from the latest `archlinux-keyring`, `manjaro-keyring` and
`biglinux-keyring`:

- every Wednesday at 23:00 UTC, on every push and on demand (Actions → Run workflow);
- it commits `pubring.gpg` and `trustdb.gpg` when they change;
- it asks [biglinux/build-package](https://github.com/biglinux/build-package)
  to build the package for the `stable` repository of
  [packages.biglinux.com.br](https://packages.biglinux.com.br). The weekly run
  builds only when the keyring changed.

The workflow needs the repository secret `REPOSITORY_TOKEN`: a GitHub token
that can start workflows in `biglinux/build-package` (Contents: read and write).

## License

GPL
