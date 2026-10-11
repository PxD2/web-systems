# PXD2 sub-hubs — how the VR Net grows

The PXD2 VR Net (`pxd2.github.io/vr`) is a web of `.pxd` worlds held on GitHub. PXD2's main hub is `PxD2/PxD2.github.io`. A **sub-hub** is any GitHub org or repo PXD2 runs for a client, partner or division (for example `mudforblood.github.io`) that publishes its own names.

## Make a sub-hub
1. Create the org or repo and turn on GitHub Pages.
2. Add `names.json` at its root, same shape as the main hub's:
   `{"registry": "Sub-hub name", "names": {"shopname": {"to": "/store/", "title": "...", "world": "store"}}}`
   `to` can be a path on the sub-hub or a full URL. `world` marks it as a VR doorway in the plaza (`store` or `page`).
3. PXD2 adds it to `hubs` in the main `names.json`:
   `{"id": "mfb", "name": "Mud for Blood hub", "registry": "https://mudforblood.github.io/names.json", "repo": "mudforblood/mudforblood.github.io"}`
4. Push. Its names now resolve in the VR Net address bar and plaza. If a sub-hub reuses a name the main hub already holds, it appears as `name.hubid.pxd`.

## Rules of the net
- The main hub's names always win. A sub-hub being down never breaks the net; its names just disappear until it's back.
- Every hub is vaulted by PXD2 Vault (git history, offline archive, Internet Archive, optional Arweave).
- Sales on any world go straight to that world owner's own payment accounts (see `OFFER.md`).
