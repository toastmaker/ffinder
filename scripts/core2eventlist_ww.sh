#!/bin/bash

# werewolf

NAME=$1
SCW=$2

if [ "$HOSTNAME" = werewolf.lambrate.inaf.it ]; then 
	LOCAL_DIR=${HOME}
else:
	LOCAL_DIR=`get_ssd`
	LOCAL_DIR="toast/$LOCAL_DIR"
fi

WORKING_DIR="${LOCAL_DIR}/${SCW}"

[ -d "${WORKING_DIR}" ] && exit 0

mkdir "${WORKING_DIR}"
cd "${WORKING_DIR}"

REV=${SCW:0:4}

if [ "${REV}" -lt 1626 ]; then
  echo "Rev ${REV}: Using OSA 10.2"
  ln -s /share/apps/mario/INTEGRAL/ic_tree/10.2/cat
  ln -s /share/apps/mario/INTEGRAL/ic_tree/10.2/ic
  ln -s /share/apps/mario/INTEGRAL/ic_tree/10.2/idx
  ln -s /anita/archivio/scw scw
  ln -s /anita/archivio/aux aux
  export ISDC_ENV=/share/apps/mario/INTEGRAL/osa10.2
else
  echo "Rev ${REV}: Using OSA 11"
  ln -s /share/apps/mario/INTEGRAL/ic_tree/11.0/cat
  ln -s /share/apps/mario/INTEGRAL/ic_tree/11.0/ic
  ln -s /share/apps/mario/INTEGRAL/ic_tree/11.0/idx
  ln -s /anita/archivio/scw scw
  ln -s /anita/archivio/aux aux
  export ISDC_ENV=/share/apps/mario/INTEGRAL/osa11
fi

export REP_BASE_PROD="${PWD}"
export ISDC_REF_CAT=${WORKING_DIR}/cat/hec/gnrl_refr_cat_0041.fits[1]
. ${ISDC_ENV}/bin/isdc_init_env.sh

echo "scw/${SCW:0:4}/${SCW}.001/swg.fits[1]" > isgri.lst

export COMMONLOGFILE="+${SCW}_log.txt"
export COMMONSCRIPT=1

og_create idxSwg=isgri.lst ogid=iipif baseDir="./" instrument=IBIS 

cd obs/iipif

IC_DIR="${REP_BASE_PROD}/ic"
CAT_DIR="${HOME}/SGR/catalog"
CATALOG="SGR1806_ii_specat.fits"
E_MIN="20"
E_MAX="250"

ibis_science_analysis ogDOL="./og_ibis.fits" startLevel=COR endLevel=DEAD

ii_pif inOG="" outOG="og_ibis.fits" inCat="${CAT_DIR}/${CATALOG}" \
		num_band=1 E_band_min=${E_MIN} E_band_max=${E_MAX} \
		mask="${IC_DIR}/ibis/mod/isgr_mask_mod_0003.fits" \
	tungAtt="${IC_DIR}/ibis/mod/isgr_attn_mod_0010.fits" \
	aluAtt="${IC_DIR}/ibis/mod/isgr_attn_mod_0011.fits" \
	leadAtt="${IC_DIR}/ibis/mod/isgr_attn_mod_0012.fits"

# barycenter=1

evts_extract group="og_ibis.fits" \
events="${SCW}_evts.fits" instrument=IBIS \
sources="${CAT_DIR}/${CATALOG}" gtiname="MERGED_ISGRI" \
pif=yes deadc=yes attach=no barycenter=0 timeformat=0 instmod=""

# copy results home
mkdir -p ${HOME}/SGR/out
cp ${scw}__evts.fits ${HOME}/SGR/out
gzip -9 ${HOME}/SGR/out/${scw}__evts.fits


