export default function useViewTransition() {
  return (callback: () => void) => {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    if (!((document as any).startViewTransition)) {
      callback();
      return;
    }
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    (document as any).startViewTransition(callback);
  };
}