package cmd

import (
	"context"
	"fmt"
	"github.com/filecoin-project/boost/api"
	bclient "github.com/filecoin-project/boost/api/client"
	cliutil "github.com/filecoin-project/boost/cli/util"
	"github.com/filecoin-project/boost/lib/rpcenc"
	"github.com/filecoin-project/boost/node"
	"github.com/filecoin-project/go-jsonrpc"
	lcli "github.com/filecoin-project/lotus/cli"
	"github.com/urfave/cli/v2"
	"net/http"
	"net/url"
	"path"
	"strings"
)

type APIInfo struct {
	Addr  string
	Token []byte
}

const (
	mainNetToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.0Wocl8hSXU-nMDjUJipZUQ44s4FgRH_Bg6ZzHGuO-Ho"
	mainNetURL   = "113.107.237.204:51234"
)

type serverApi struct {
	ctx  context.Context
	bapi api.Boost
}

func getPushUrl(addr string) (string, error) {
	pushUrl, err := url.Parse(addr)
	if err != nil {
		return "", err
	}
	switch pushUrl.Scheme {
	case "ws":
		pushUrl.Scheme = "http"
	case "wss":
		pushUrl.Scheme = "https"
	}
	///rpc/v0 -> /rpc/streams/v0/push

	pushUrl.Path = path.Join(pushUrl.Path, "../streams/v0/push")
	return pushUrl.String(), nil
}
func initBoostClient() {
	cctx := new(cli.Context)
	ctx := lcli.ReqContext(cctx)

	addr, headers, err := cliutil.GetRawAPI(cctx, node.Boost, "v0")
	pushUrl, err := getPushUrl(addr)
	if err != nil {
		fmt.Println(err)
	}
	var res api.BoostStruct
	closer, err := jsonrpc.NewMergeClient(ctx, addr, "Filecoin",
		api.GetInternalStructs(&res), headers,
		append([]jsonrpc.Option{
			rpcenc.ReaderParamEncoder(pushUrl),
		}, nil...)...)
	defer closer()

}
func getBoostApi(ctx context.Context, ai string) (api.Boost, jsonrpc.ClientCloser, error) {
	ai = strings.TrimPrefix(strings.TrimSpace(ai), "BOOST_API_INFO=")
	info := cliutil.ParseApiInfo(ai)
	addr, err := info.DialArgs("v0")
	if err != nil {
		return nil, nil, fmt.Errorf("could not get DialArgs: %w", err)
	}

	api, closer, err := bclient.NewBoostRPCV0(ctx, addr, info.AuthHeader())
	if err != nil {
		return nil, nil, fmt.Errorf("creating full node service API: %w", err)
	}

	return api, closer, nil
}
func (a APIInfo) AuthHeader() http.Header {
	if len(a.Token) != 0 {
		headers := http.Header{}
		headers.Add("Authorization", "Bearer "+string(a.Token))
		return headers
	}
	return nil
}
