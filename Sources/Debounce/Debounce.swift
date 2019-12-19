import Foundation

/**
 Wraps a function in a new function that will only execute the wrapped function if `delay` has passed without this function being called.

 - Parameter delay: A `DispatchTimeInterval` to wait before executing the wrapped function after last invocation.
 - Parameter queue: The queue to perform the action on. Defaults to the main queue.
 - Parameter action: A function to debounce. Can accept one argument (could be a Tuple).

 - Returns: A new function that will only call `action` if `delay` time passes between invocations.
 */
public func debounce<Context>(delay: DispatchTimeInterval, queue: DispatchQueue = .main, action: @escaping ((Context) -> Void)) -> (Context) -> Void {

    var currentWorkItem: DispatchWorkItem?

    return { (context: Context) in
        currentWorkItem?.cancel()
        currentWorkItem = DispatchWorkItem {
            action(context)
        }
        queue.asyncAfter(deadline: .now() + delay, execute: currentWorkItem!)
    }
}
