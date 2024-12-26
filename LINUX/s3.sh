# Copying to S3
aws s3 cp /root/.m2/twms-hussmann-hussmann s3://athenalogss/twms-hussmann-hussmann/ --recursive

#Dowloading from s3
aws s3 cp s3://athenalogss/twms-hussmann-hussmann/ . --recursive 


#exclude a folder in the s3 and copy the all folders
aws s3 cp s3://athenalogss/ . --recursive --exclude "Unsaved/*"