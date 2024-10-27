#!/bin/bash
# Check if DOCKER_TRAIN_IMAGE is set
if [ -z "$DOCKER_TRAIN_IMAGE" ]; then
  echo "DOCKER_TRAIN_IMAGE environment variable is not set. Please set it in GitHub Secrets."
  exit 1
fi

# hyperparameters
estimators=(50 100 150)
depths=(5 10 15)

# Loop over hyperparameters and create job files
for er in "${estimators[@]}"; do
    for dp in "${depths[@]}"; do
        job_name="model-training-er${er}-dp${dp}-$(date +%s)"
        
        # Generate the job YAML file
        cat <<EOF > ${job_name}.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: ${job_name}
spec:
  parallelism: 3  # Number of parallel pods per job
  completions: 3  # Total number of pods to complete
  template:
    spec:
      containers:
        - name: model-container
          image: ${DOCKER_TRAIN_IMAGE}
          command: ["python", "train.py"]
          args: ["--n_estimators", "${er}", "--max_depth", "${dp}"]
          resources:
            requests:
              memory: "512Mi"
              cpu: "250m"
            limits:
              memory: "1Gi"
              cpu: "500m"
          volumeMounts:
            - mountPath: "/models"
              name: model-storage
      volumes:
        - name: model-storage
          persistentVolumeClaim:
            claimName: my-pvc
      restartPolicy: Never
  backoffLimit: 4
EOF

        # Apply the job YAML file
        kubectl apply -f ${job_name}.yaml

        # Optionally, delete the YAML file to keep the workspace clean
        rm ${job_name}.yaml
    done
done
