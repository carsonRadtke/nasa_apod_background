import {NasaHandler} from "nasa_api.js"

function MsgHandler() {

    if (arguments.length < 1) {
        return
    }

    let args = arguments[0].split(" ")

    let func = this[args[0]]
    if (func) {
        func(args.splice(1))
    }
    
}

MsgHandler.prototype["_nasa"] = () => {

    NasaHandler(arguments)

}



export { message_handler }