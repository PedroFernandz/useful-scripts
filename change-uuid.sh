#!/bin/bash

    # This if statement checks whether the script has been called with at least one argument. If not, it prints a usage message and exits with an error code.
    echo "Usage: ${0} <disk_path1> [disk_path2] ..."
    exit 1
fi

for DISK in "${@}"; do
    # This for loop iterates over each argument passed to the script.
    if [ ! -b "${DISK}" ]; then
        # This if statement checks whether the current argument is a valid block device. If not, it prints an error message and exits with an error code.
        echo "Error: ${DISK} is not a valid block device."
        exit 2
    fi

    # This section changes the UUID of the current block device.
    OLD_UUID=$(blkid -s UUID -o value "${DISK}")
    # This command uses the blkid tool to get the current UUID of the block device.
    NEW_UUID=$(uuidgen)
    # This command generates a new UUID using the uuidgen tool.
    tune2fs -U "${NEW_UUID}" "${DISK}"
    # This command uses the tune2fs tool to change the UUID of the block device to the new UUID.
    echo "UUID changed on ${DISK}: ${OLD_UUID} -> ${NEW_UUID}"

    # This section updates the GRUB configuration files to use the new UUID.
    GRUB_FILES="/etc/grub*"
    # This variable specifies the pattern of filenames to search for.
    for file in ${GRUB_FILES}; do
        # This for loop iterates over each file that matches the pattern.
        if grep -q "${OLD_UUID}" "${file}"; then
            # This if statement checks whether the old UUID appears in the current file. If so, it updates the file.
            echo "Updating UUID in ${file}"
            sed -i "s/${OLD_UUID}/${NEW_UUID}/g" "${file}"
            # This command uses the sed tool to replace all instances of the old UUID with the new UUID in the current file.
        fi
    done
done

echo "Process completed."
