DIR='/opt/projects/domestic_violence'
STATES=`cat $DIR/state_abrevs.txt`

for state in $STATES ; do
    mkdir $state && rm -rf $state && mkdir $state

    url="https://www.domesticshelters.org/${state}"
    pushd $state &>/dev/null
    wget $url 2>/dev/null
    city_links=`fgrep '<li><a href=' $state | grep program-shelters | sed -r 's/[^"]*"([^"]*)".*/\1/' | sed 's/^/https:\/\/www.domesticshelters.org/'`
    for link in ${city_links} ; do
        city=`echo $link | awk -F'/' '{print $5}'`
        wget $link  -O - 2>/dev/null | grep 'h2><a hr' | awk -F'[/<>]' '{print $9","$6","$5}'
        sleep .5
    done
    popd &>/dev/null
done > all_centers.csv
