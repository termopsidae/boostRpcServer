module github.com/zhcyueliyangzi/boostRpcServer

go 1.16

replace github.com/filecoin-project/filecoin-ffi => ./extern/boost/extern/filecoin-ffi

replace github.com/filecoin-project/boost => ./extern/boost

require (
	github.com/buger/goterm v1.0.3
	github.com/chzyer/readline v0.0.0-20180603132655-2972be24d48e
	github.com/docker/go-units v0.4.0
	github.com/dustin/go-humanize v1.0.0
	github.com/fatih/color v1.13.0
	github.com/filecoin-project/boost v0.0.0-00010101000000-000000000000
	github.com/filecoin-project/dagstore v0.5.3
	github.com/filecoin-project/go-address v1.0.0
	github.com/filecoin-project/go-cbor-util v0.0.1
	github.com/filecoin-project/go-commp-utils v0.1.3
	github.com/filecoin-project/go-data-transfer v1.15.2
	github.com/filecoin-project/go-fil-markets v1.23.2
	github.com/filecoin-project/go-jsonrpc v0.1.5
	github.com/filecoin-project/go-legs v0.4.9
	github.com/filecoin-project/go-paramfetch v0.0.4
	github.com/filecoin-project/go-state-types v0.1.10
	github.com/filecoin-project/lotus v1.17.0
	github.com/gbrlsnchs/jwt/v3 v3.0.1
	github.com/google/uuid v1.3.0
	github.com/hashicorp/go-multierror v1.1.1
	github.com/ipfs/go-cid v0.2.0
	github.com/ipfs/go-cidutil v0.1.0
	github.com/ipfs/go-datastore v0.5.1
	github.com/ipfs/go-log/v2 v2.5.1
	github.com/ipld/go-car v0.4.1-0.20220707083113-89de8134e58e
	github.com/ipld/go-car/v2 v2.4.2-0.20220707083113-89de8134e58e
	github.com/ipld/go-ipld-prime v0.18.0
	github.com/libp2p/go-libp2p-core v0.16.1
	github.com/mitchellh/go-homedir v1.1.0
	github.com/multiformats/go-multiaddr v0.5.0
	github.com/multiformats/go-multibase v0.0.3
	github.com/multiformats/go-multihash v0.2.0
	github.com/multiformats/go-varint v0.0.6
	github.com/stretchr/testify v1.7.1
	github.com/urfave/cli/v2 v2.8.1
	gopkg.in/cheggaaa/pb.v1 v1.0.28
)
