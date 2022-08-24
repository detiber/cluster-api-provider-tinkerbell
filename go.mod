module github.com/tinkerbell/cluster-api-provider-tinkerbell

go 1.16

require (
	github.com/go-logr/logr v1.2.3
	github.com/google/uuid v1.3.0
	github.com/onsi/gomega v1.19.0
	github.com/prometheus/common v0.30.0 // indirect
	github.com/spf13/pflag v1.0.5
	github.com/tinkerbell/tink v0.0.0-20210910200746-3743d31e0cf0
	go.uber.org/atomic v1.9.0 // indirect
	google.golang.org/grpc v1.40.0
	google.golang.org/protobuf v1.28.0
	k8s.io/api v0.25.0
	k8s.io/apimachinery v0.25.0
	k8s.io/client-go v0.25.0
	k8s.io/component-base v0.22.1
	k8s.io/klog/v2 v2.70.1
	k8s.io/utils v0.0.0-20220728103510-ee6ede2d64ed
	sigs.k8s.io/cluster-api v0.4.3
	sigs.k8s.io/controller-runtime v0.9.7
	sigs.k8s.io/yaml v1.2.0
)
