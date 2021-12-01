[wordpress-node-a]
%{ for ip in wp-node-a ~}
${ip}
%{ endfor ~}
[wordpress-node-b]
%{ for ip in wp-node-b ~}
${ip}
%{ endfor ~}