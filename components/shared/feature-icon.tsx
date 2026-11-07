import type { SVGProps } from "react";

import { IconContainer } from "./icon-container";

type Props = {
  icon: React.FC<SVGProps<SVGSVGElement>>;
  className?: string;
};

export function FeatureIcon({ icon, className }: Props) {
  return <IconContainer className={className} icon={icon} iconSize="sm" size="sm" />;
}
