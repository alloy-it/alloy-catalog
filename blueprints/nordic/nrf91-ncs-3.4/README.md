# Nordic nRF91 — NCS v3.4

Development environment for **nRF91** (nRF9160, nRF9161) with **nRF Connect SDK v3.4.0**.

## Included

- nRF Connect SDK **v3.4.0** (catalog: `sdk.nordic.nrf-connect-sdk@3.4.0`)
- Zephyr SDK **1.0.1** with ARM toolchain
- Python **3.12** (pinned) + `/opt/zephyr/venv` for west and SDK pip deps
- Nordic Command Line Tools (nrfjprog, mergehex)
- West **1.3.0**

## Other NCS versions

| Blueprint | NCS version |
| --------- | ----------- |
| `nordic/nrf91-ncs-3.4` | v3.4.0 (this blueprint) |
| `nordic/nrf91-ncs-3.3` | v3.3.4 |
| `nordic/nrf91-ncs-3.2` | v3.2.4 |
| `nordic/nrf91` | v2.9.0 (legacy) |

## Quick start

```bash
source /etc/profile.d/05-zephyr-python.sh
cd /opt/nordic/ncs/v3.4.0
west build -b nrf9160dk_nrf9160_ns nrf/samples/cellular/hello_world
west flash
```

## References

- [nRF Connect SDK docs](https://developer.nordicsemi.com/nRF_Connect_SDK/doc/latest/)
- [NCS releases](https://github.com/nrfconnect/sdk-nrf/releases)
