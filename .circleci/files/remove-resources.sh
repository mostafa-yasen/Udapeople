export STACKS=($(
  aws cloudformation list-stacks \
  --query "StackSummaries[*].StackName" \
  --stack-status-filter CREATE_COMPLETE \
  --output text \
))
echo "Stack names: ${STACKS[@]}"
export OldWorkflowID=$(curl --insecure https://kvdb.io/McRAzFezPEMhjfEApiab4d/old_workflow_id)
echo "OldWorkflowID: ${OldWorkflowID}"

if [[ "${STACKS[@]}" =~ "${OldWorkflowID}" ]]
then
  echo "Removing..."
  aws s3 rm "s3://udapeople-${OldWorkflowID}" --recursive
  aws cloudformation delete-stack --stack-name "udapeople-backend-${OldWorkflowID}"
  aws cloudformation delete-stack --stack-name "udapeople-frontend-${OldWorkflowID}"
  echo "Removed."
else
  echo "Unable to match OldWorkflowID ${OldWorkflowID} to any stack"
  echo "Stacks: ${STACKS[@]}"
fi
