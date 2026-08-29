# Nordic nRF54 — NCS v3.4

Development environment for **nRF54** (nRF54H20, nRF54L15) with **nRF Connect SDK v3.4.0**.

NCS 3.3+ adds nRF54L05 DK support. Sibling blueprints: `nrf54-ncs-3.3`, `nrf54-ncs-3.2`, legacy `nrf54` (v2.9.0).

```bash
source /etc/profile.d/05-zephyr-python.sh
cd /opt/nordic/ncs/v3.4.0
west build -b nrf54h20dk_nrf54h20 nrf/samples/hello_world
```
