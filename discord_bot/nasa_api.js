function NasaHandler() {

    if (arguments.length < 1) {
        return
    }

    let args = arguments

    let func = this[args[0]]
    if (func)
        func(args.splice(1))

}

NasaHandler.prototype["apod"] = () => {

    console.log("apod");

}