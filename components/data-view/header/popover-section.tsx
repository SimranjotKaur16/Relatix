import type { ReactNode } from "react";

export function PopoverSection({ label, children }: { label: string; children: ReactNode }) {
  return (
    <div className="flex flex-col gap-1.5 p-3">
      <span className="text-[11px] font-medium uppercase tracking-wide text-muted-foreground">{label}</span>

      {children}
    </div>
  );
}
