#!/bin/bash

# Generate list.txt using kubectl, awk, and formatting the output to include both node name and IP address
kubectl get nodes -o wide | awk 'NR>1{print$1, $6}' > list.txt
echo "Generated list.txt"

# Create YAML files from the template and replace both SOURCE_NODE_NAME and SOURCE_NODE_IP
while read -r node_name node_ip; do
    # Remove any trailing whitespace or newline characters from the node_name and node_ip
    node_name=$(echo "$node_name" | tr -d '[:space:]')
    node_ip=$(echo "$node_ip" | tr -d '[:space:]')

    # Create a YAML file from the template for the current node_name
    cp template.conf "${node_name}.yaml"
    echo "Created ${node_name}.yaml"

    # Replace SOURCE_NODE_NAME and SOURCE_NODE_IP in the YAML file with the current node_name and node_ip
    sed -i "s/SOURCE_NODE_NAME/$node_name/g" "${node_name}.yaml"
    sed -i "s/SOURCE_NODE_IP/$node_ip/g" "${node_name}.yaml"
    echo "Replaced SOURCE_NODE_NAME with $node_name and SOURCE_NODE_IP with $node_ip in ${node_name}.yaml"
done < list.txt
