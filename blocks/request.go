package blocks

import (
	"math/rand"

	"github.com/epfl-dcsl/schedsim/engine"
)

// Request is the basic request type
type Request struct {
	InitTime    float64
	ServiceTime float64
	RemainingServiceTime float64
}

// GetDelay returns the request latency from the time it was sent till the time
// processing was over
func (r Request) GetDelay() float64 {
	return engine.GetTime() - r.InitTime
}

// GetServiceTime returns the request service time
func (r Request) GetServiceTime() float64 {
	return r.ServiceTime
}

// GetServiceTime returns the request service time
func (r Request) GetRemainingServiceTime() float64 {
	return r.RemainingServiceTime
}

// SubServiceTime reduces service time by t
func (r *Request) SubServiceTime(t float64) {
	r.RemainingServiceTime -= t
}

// StealableReq is a request that can be stolen and is used to account for steals
type StealableReq struct {
	Request
	stolen bool
}

// MonitorReq is a request used to monitor queue depths
type MonitorReq struct {
	Request
	initLength  int
	finalLength int
}

func (r MonitorReq) getInitLen() int {
	return r.initLength
}

func (r MonitorReq) getFinalLen() int {
	return r.finalLength
}

type ColoredReq struct {
	Request
	color int
}

// ReqCreator is a used by generators to create the appropriate type of requests
type ReqCreator interface {
	NewRequest(serviceTime float64) engine.ReqInterface
}

// SimpleReqCreator creates structs of type Request
type SimpleReqCreator struct{}

// NewRequest returns a new Request struct
func (rc SimpleReqCreator) NewRequest(serviceTime float64) engine.ReqInterface {
	return &Request{InitTime: engine.GetTime(), ServiceTime: serviceTime, RemainingServiceTime: serviceTime}
}

// StealableReqCreator creates structs of type StealableReq
type StealableReqCreator struct{}

// NewRequest returns a new StealableReq struct
func (rc StealableReqCreator) NewRequest(serviceTime float64) engine.ReqInterface {
	return &StealableReq{Request{InitTime: engine.GetTime(), ServiceTime: serviceTime, RemainingServiceTime: serviceTime}, false}
}

// MonitorReqCreator creates structs of type MonitorReq
type MonitorReqCreator struct{}

// NewRequest returns a new MonitorReq struct
func (rc MonitorReqCreator) NewRequest(serviceTime float64) engine.ReqInterface {
	return &MonitorReq{Request{InitTime: engine.GetTime(), ServiceTime: serviceTime, RemainingServiceTime: serviceTime}, 0, 0}
}

type ColoredReqCreator struct{}

func (rc ColoredReqCreator) NewRequest(serviceTime float64) engine.ReqInterface {
	return &ColoredReq{Request{InitTime: engine.GetTime(), ServiceTime: serviceTime, RemainingServiceTime: serviceTime}, rand.Int() % 2}
}
