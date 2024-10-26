#!/bin/bash
# Check if DOCKER_TRAIN_IMAGE is set
if [ -z "$DOCKER_TRAIN_IMAGE" ]; then
  echo "DOCKER_TRAIN_IMAGE environment variable is not set. Please set it in GitHub Secrets."
  exit 1
fi


# Define hyperparameters to sweep over
estimators=(50 100 150)
depths=(5 10 15)

for er in "${estimators[@]}"
do
    for dp in "${depths[@]}"
    do
        job_name="model-training-er${er}-dp${dp}"
        cat <<EOF > ${job_name}.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: ${job_name}
spec:
  template:
    spec:
      containers:
        - name: model-container
          image:  ${DOCKER_TRAIN_IMAGE}
          command: ["python", "train.py"]
          args: ["--n_estimators", "${er}", "--max_depth", "${dp}"]
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
        # Launch the job
        kubectl apply -f ${job_name}.yaml
    done
done
