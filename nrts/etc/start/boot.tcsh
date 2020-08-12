#!/bin/csh -f
#
# NRTS boot startup script
#

alias pause 'echo "Press return to continue"; set reply=$<; echo "Continuing..."'

# Load the login environment

set envrc = ~nrts/.envrc
if (-e $envrc) then
    source $envrc
else
    echo "warning: missing $envrc"
endif

set path = ($NRTS_HOME/scripts $NRTS_HOME/bin /opt/local/bin $path)

# Make sure that permissions are correct

if ( -e $NRTS_HOME/scripts/nrtsSetPerms ) then
    nrtsSetPerms $NRTS_HOME/bin
else
    echo "WARNING: missing nrtsSetPerms"
endif

# If this is a new deployment, build the disk loops

if ($?BOOT_BUILD_FLAG && -e $BOOT_BUILD_FLAG) then
    echo "Boot build flag is set, building fresh disk loops"
    isiDeleteEverything >& /dev/null
    if ($status != 0) then
        echo "isiDeleteEverything failed!"
        goto failure
    endif
    isiCreateDiskLoops >& /dev/null
    if ($status != 0) then
        echo "isiCreateDiskLoops failed!"
        goto failure
    endif

	# WARNING WARNING WARNING: below CHOWN is only valid at astation. 
	# On idahub doing CHOWN on ~nrts will trash ~tunnel perms.
    #    chown -R nrts:nrts /usr/home/nrts

    rm $BOOT_BUILD_FLAG
endif

# Start all data servers

foreach server (isid)
    $NRTS_HOME/etc/init.d/$server bounce
end

isidl isi=shub   coco -bd  -noseedlink
isidl isi=shub   ibfo -bd  -noseedlink


exit 0

