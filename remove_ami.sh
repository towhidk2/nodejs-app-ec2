#!/bin/bash
ami_name=amzon-linux-nodeapp-3
ami_id=$(aws ec2 describe-images --filters "Name=name,Values=$ami_name" --query "Images[*].[ImageId]" --output text)
snapshot_ids="$(aws ec2 describe-images --image-ids $ami_id --query 'Images[*].BlockDeviceMappings[*].Ebs.SnapshotId' --output text)"
aws ec2 deregister-image --image-id $ami_id
for snapshot in $snapshot_ids; do aws ec2 delete-snapshot --snapshot-id $snapshot; done
echo "Successfully removed AMI: $ami_id and Snapshots: $snapshot_ids"