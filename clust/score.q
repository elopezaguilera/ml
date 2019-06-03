\d .ml

/---Scoring metrics---\

/Davies-Bouldin index (euclidean distance only)
/* x = results table (idx, clt, pts) produced by .clust.ml.cure/dbscan/hc/kmeans
clust.dbindex:{
 n:count a:avg each p:value exec pts by clt from x;
 s:avg each clust.i.scdist[`edist]'[p;a];
 dm:clust.i.scdist[`edist;a]each a;
 (sum clust.i.dbi[s;dm;t]each t:til n)%n}

/Dunn Index
/* x = results table (idx, clt, pts) produced by .clust.ml.cure/dbscan/hc/kmeans
/* y = distance metric as a symbol
clust.dunn:{
 t:til count p:value exec pts by clt from x;
 mn:(min/)clust.i.dinter[y;p;t]each t;
 mx:max(max/)each{clust.i.scdist[y;x]each x}[;y]each p;
 mn%mx}

/Silhouette coefficient for entire dataset
/* x = results table (idx, clt, pts) produced by .clust.ml.cure/dbscan/hc/kmeans
/* y = distance metric as a symbol
clust.silhouette:{t:til count p:value exec pts by clt from x;avg raze clust.i.silc[y;p;t]'[t;p]}

/---Utils---\

/dbindex given inter/intra cluster distances
/* s = sigma, avg intracluster distances
/* c = intercluster distances between centroids
/* x = distinct cluster indicies
/* y = index of current cluster
clust.i.dbi:{[s;c;x;y]
 m:@[;where x<>y]x,\:y;
 max{%[(+). x z;y[;]. z]}[s;c]each m}

/intercluster distances
/* df = distance metric
/* p  = points per cluster
clust.i.dinter:{[df;p;x;y](min/)each{j:y[z];clust.i.scdist[x;j 0]each j 1}[df;p]each@[;where x<>y]x,\:y}

/Silhouette coefficient for each cluster
/* pcl = points in cluster
clust.i.silc:{[df;p;x;y;pcl]k:1%count[pcl]-1;clust.i.silp[df;p;x;y;pcl;k]each pcl}

/Silhouette coefficient for single point
/* k = 1/(n-1), where n is the number of points in cluster y
/* j = single point
clust.i.silp:{[df;p;x;y;pcl;k;j]
 a:k*sum{x where 0<>x}clust.i.scdist[df;pcl;j];
 b:min avg each clust.i.scdist[df;;j]each p x except y;
 (b-a)%max(a;b)}

/distance calc
/* x = distance metric
/* y = list of points
/* z = single point
clust.i.scdist:{clust.i.dd[x]each y-\:z}