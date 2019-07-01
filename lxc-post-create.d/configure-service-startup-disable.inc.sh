#!/bin/bash

# prevent daemons from being started right after installation, which would fail
# inside the chroot environment:
echo -e '#!/bin/bash\nexit 101' > "$TGT_ROOT"/usr/sbin/policy-rc.d
chmod +x "$TGT_ROOT"/usr/sbin/policy-rc.d
