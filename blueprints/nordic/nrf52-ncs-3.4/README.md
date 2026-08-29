# Nordic nRF52 — NCS v3.4

Development environment for **nRF52** (nRF52832, nRF52840) with **nRF Connect SDK v3.4.0**.

See `nordic/nrf91-ncs-3.4/README.md` for the full NCS version matrix. Sibling blueprints: `nrf52-ncs-3.3`, `nrf52-ncs-3.2`, legacy `nrf52` (v2.9.0).

```bash
source /etc/profile.d/05-zephyr-python.sh
cd /opt/nordic/ncs/v3.4.0
west build -b nrf52840dk_nrf52840 nrf/samples/hello_world
```
