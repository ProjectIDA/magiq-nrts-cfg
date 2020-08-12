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

isidl isi=aak1-gci          aak  -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=abpo-fw           abpo -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II 
isidl isi=fsuhub:39138      arti -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=ascn              ascn -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=bfo-kit-gw        bfo  -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=localhost:59233   borg -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=bork-fw           bork -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=cmla-oac-gw:39138 cmla -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=coco-fw          coco -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=dgar             dgar -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=efi-fw           efi  -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=localhost:59200  erm  -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=esk              esk  -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=localhost:59214  ffc  -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=hope-fw          hope -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=jts-gw           jts  -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=localhost:59181  kapi -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=kdak-gw:39137    kdak -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=fsuhub:39138     kiv  -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=kurk-fw          kurk -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=kwjn-fw          kwjn -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II scl=nrts
isidl isi=fsuhub:39138     lvz  -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=mbar-fw          mbar -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=msey-fw          msey -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=localhost:59232  msvf -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=nil-fw           nil  -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=localhost:59243  nna  -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=fsuhub:39138     obn  -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=palk-fw          palk -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=pfo-fw           pfo  -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=localhost:59227  rayn -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=rpn1-gci         rpn  -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=sacv-isp-gw      sacv -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=shel-fw          shel -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=simi-gw          simi -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=sur              sur  -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=tau-fw           tau  -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=fsuhub:39138     tly  -bd rechan:bhz20=bhz00,bh120=bh100,bh220=bh200,lhz20=lhz00,lh120=lh100,lh220=lh200,vmu20=vmu00,vmv20=vmv00,vmw20=vmw00,lnz20=lnz00,ln120=ln100,ln220=ln200 seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=uoss             uoss -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=localhost:59223  wrab -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=bfo-kit-gw       xbfo -bd seedlink=rtserve.ida.ucsd.edu:16001:512:500:II scl=nrts
isidl isi=xpfo-fw:39138    xpfo -bd seedlink=rtserve.ida.ucsd.edu:16000:512:500:II
isidl isi=valt-fw:39136    valt -bd -noseedlink
isidl isi=bfo-kit-gw       bfom1 -bd -noseedlink
isidl isi=femto.ucsd.edu   ibfo -bd  seedlink=rtserve.ida.ucsd.edu:16000:512:500:II


exit 0

